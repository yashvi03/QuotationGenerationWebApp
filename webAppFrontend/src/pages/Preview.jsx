import { useEffect, useState, useCallback, useRef } from "react";
import { useNavigate, useParams } from "react-router-dom";
import axiosInstance from "../services/axiosInstance";
import "../App.css";
import ConfirmationModal from "../components/ConfirmationModel";
import { editFinalQuotation } from "../services/api";
import { useLocation } from "react-router-dom";

const Preview = () => {
  const [quotation, setQuotation] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isConfirmed, setIsConfirmed] = useState(false);
  const [pdfBlob, setPdfBlob] = useState(null);
  const [pdfUrl, setPdfUrl] = useState(null);
  const [pdfError, setPdfError] = useState(null);
  const [isGeneratingPdf, setIsGeneratingPdf] = useState(false);
  const [isSharing, setIsSharing] = useState(false);
  const [isDownloading, setIsDownloading] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const { id } = useParams();
  const pdfGeneratedRef = useRef(false);

  // Scroll to top function
  const scrollToTop = useCallback(() => {
    window.scrollTo({ top: 0, left: 0, behavior: "smooth" });
    // Also try direct scroll in case smooth doesn't work
    setTimeout(() => {
      window.scrollTo(0, 0);
    }, 100);
  }, []);

  // Scroll to top on component mount and route changes
  useEffect(() => {
    scrollToTop();
  }, [scrollToTop, id]);

  // Scroll to top when loading state changes
  useEffect(() => {
    if (!isLoading) {
      scrollToTop();
    }
  }, [isLoading, scrollToTop]);

  // Scroll to top when quotation data is loaded
  useEffect(() => {
    if (quotation) {
      setTimeout(() => {
        scrollToTop();
      }, 100);
    }
  }, [quotation, scrollToTop]);

  const getQuotationId = () => {
    if (id) return id;
    if (location.state?.quotationId) {
      localStorage.setItem("quotationId", location.state.quotationId);
      return location.state.quotationId;
    }
    return localStorage.getItem("quotationId");
  };

  const quotationId = getQuotationId();
  console.log("preview qid", quotationId);

  const handleGeneratePDF = useCallback(
    async (finalQuotationId) => {
      if (isGeneratingPdf) {
        console.log("PDF generation already in progress");
        return null;
      }

      if (!quotation?.cards?.length || !quotation?.customer) {
        console.error("Cannot generate PDF: Missing quotation data", {
          hasCards: !!quotation?.cards?.length,
          hasCustomer: !!quotation?.customer,
        });
        setPdfError("Cannot generate PDF: Missing quotation data");
        return null;
      }

      const timeoutDuration = 10000; // 10 seconds timeout
      const timeoutId = setTimeout(() => {
        if (isGeneratingPdf) {
          setIsGeneratingPdf(false);
          setPdfError("PDF generation timed out. Please try again.");
          console.error("PDF generation timed out after 10 seconds");
        }
      }, timeoutDuration);

      try {
        setIsGeneratingPdf(true);
        setPdfError(null);

        const cleanQuotationId = finalQuotationId.replace("WIP_", "");
        console.log("Sending PDF request for quotationId:", cleanQuotationId);

        const payload = {
          tableData: quotation.cards.map((card) => ({
            card_id: card.card_id,
            type: card.type,
            size: card.size,
            items: card.items.map((item) => ({
              article: item.article,
              cat1: item.cat1,
              cat2: item.cat2,
              cat3: item.cat3,
              final_price: item.final_price,
              quantity: item.quantity,
              mc_name: item.mc_name,
            })),
          })),
          customer: {
            customer_id: quotation.customer.customer_id,
            name: quotation.customer.name,
            project_name: quotation.customer.project_name,
          },
        };

        console.log("PDF payload size:", JSON.stringify(payload).length);

        const response = await axiosInstance.post(
          `/download_pdf/${cleanQuotationId}`,
          payload,
          {
            responseType: "blob",
            timeout: timeoutDuration,
          }
        );

        console.log("PDF API response received, size:", response.data?.size);
        if (!response.data || response.data.size === 0) {
          throw new Error("Received empty PDF from server");
        }

        const blob = new Blob([response.data], { type: "application/pdf" });
        console.log("PDF Blob created, size:", blob.size);

        setPdfBlob(blob);

        if (pdfUrl) {
          try {
            window.URL.revokeObjectURL(pdfUrl);
            console.log("Previous PDF URL revoked");
          } catch (err) {
            console.warn("Failed to revoke previous URL:", err);
          }
        }

        const url = window.URL.createObjectURL(blob);
        console.log("PDF URL created:", url);
        setPdfUrl(url);
        setPdfError(null);
        clearTimeout(timeoutId);

        // Scroll to top after PDF is generated
        setTimeout(() => scrollToTop(), 300);

        return url;
      } catch (error) {
        console.error("Error in PDF generation:", error);
        setPdfError(`Error generating PDF: ${error.message}`);
        clearTimeout(timeoutId);
        return null;
      } finally {
        setIsGeneratingPdf(false);
      }
    },
    [pdfUrl, isGeneratingPdf, quotation, scrollToTop]
  );

  useEffect(() => {
    if (!quotationId) {
      setError("No quotation ID found");
      setIsLoading(false);
      return;
    }

    const fetchQuotation = async () => {
      try {
        let response;
        if (quotationId.startsWith("WIP_")) {
          response = await axiosInstance.get(
            `/preview_quotation/${quotationId}`
          );
        } else {
          response = await axiosInstance.get(
            `/preview_final_quotation/${quotationId}`
          );
        }
        if (!response.data) throw new Error("No data received");
        console.log("Quotation data:", response.data);
        if (!response.data.cards?.length || !response.data.customer) {
          throw new Error("Invalid quotation data: Missing cards or customer");
        }
        setQuotation(response.data);
        if (!quotationId.startsWith("WIP_")) {
          setIsConfirmed(true);
        }

        // Scroll to top after quotation is loaded
        setTimeout(() => scrollToTop(), 100);
      } catch (error) {
        setError(error.message || "Error fetching quotation");
        console.error("Error fetching quotation:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchQuotation();
  }, [quotationId, scrollToTop]);

  const getMarginForItem = (mcName) => {
    if (!quotation?.margins || !mcName) return 0;
    const marginObj = quotation.margins.find(
      (margin) => margin.mc_name === mcName
    );
    return marginObj ? marginObj.margin : 0;
  };

  const calculateGrandTotal = () => {
    if (!quotation?.cards) return 0;
    return quotation.cards
      .reduce((total, card) => {
        const cardTotal = card.items.reduce((sum, item) => {
          return sum + parseFloat(item.final_price) * item.quantity;
        }, 0);
        return total + cardTotal;
      }, 0)
      .toFixed(2);
  };

  const handleSaveAndExit = useCallback(() => {
    navigate("/");
  }, [navigate]);

  const handleConfirmAction = useCallback(async () => {
    if (!quotation) return;

    try {
      setIsLoading(true);
      const finalQuotationId = quotationId.replace("WIP_", "");
      const wipQuotation = {
        quotation_id: finalQuotationId,
        card_ids: quotation.cards.map((card) => card.card_id),
        margin_ids: quotation.margins.map((margin) => margin.margin_id),
        customer_id: quotation.customer.customer_id,
      };

      const response = await axiosInstance.post(
        "/final_quotation",
        wipQuotation
      );
      const confirmedQuotationId =
        response.data.quotation_id || finalQuotationId;

      await axiosInstance.delete(`/delete_quotation/${quotationId}`);
      const quotationResponse = await axiosInstance.get(
        `/preview_final_quotation/${confirmedQuotationId}`
      );
      if (
        !quotationResponse.data.cards?.length ||
        !quotationResponse.data.customer
      ) {
        throw new Error("Invalid confirmed quotation data");
      }
      setQuotation(quotationResponse.data);

      setIsModalOpen(false);
      setIsConfirmed(true);
      localStorage.setItem("quotationId", confirmedQuotationId);
      navigate(`/preview/${confirmedQuotationId}`, { replace: true });

      // Scroll to top after confirmation
      setTimeout(() => scrollToTop(), 100);
    } catch (error) {
      setError(error.message || "Error confirming quotation");
      console.error("Error:", error);
    } finally {
      setIsLoading(false);
    }
  }, [quotation, quotationId, navigate, scrollToTop]);

  const handleEdit = useCallback(async () => {
    if (!quotation) return;
    const payload = {
      customer_id: quotation.customer.customer_id,
      card_ids: quotation.cards.map((card) => card.card_id),
      margin_ids: quotation.margins.map((margin) => margin.margin_id),
    };
    const response = await editFinalQuotation(payload);
    navigate("/home", { state: { quotationId: response.data.quotation_id } });
    localStorage.setItem("quotationId", response.data.quotation_id);
  }, [navigate, quotation]);

  if (isLoading) {
    return (
      <div className="p-4 sm:p-6 text-gray-600 flex justify-center items-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-orange-600 mx-auto"></div>
          <p className="mt-4">Loading...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return <div className="p-4 sm:p-6 text-red-500">Error: {error}</div>;
  }

  return (
    <div className="p-4 sm:p-6 max-w-4xl mx-auto bg-gray-100 min-h-screen">
      <div className="mb-6 bg-white p-4 sm:p-6 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-2xl font-bold mb-6 text-orange-600 border-b pb-3">
          Quotation Preview
        </h1>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-6">
          <div className="bg-orange-50 p-4 rounded-lg border border-orange-100">
            <p className="text-sm text-orange-700 mb-1">Quotation ID</p>
            <p className="font-semibold text-gray-800">
              {quotation?.quotation_id || "N/A"}
            </p>
          </div>
          <div className="bg-orange-50 p-4 rounded-lg border border-orange-100">
            <p className="text-sm text-orange-700 mb-1">Customer</p>
            <p className="font-semibold text-gray-800">
              {quotation?.customer?.name || "N/A"}
            </p>
          </div>
        </div>
      </div>

      {isConfirmed && (
        <div className="mb-6 bg-white p-4 rounded-lg shadow-sm border border-gray-200">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-semibold text-gray-700">Actions</h2>
          </div>
          <div className="flex gap-2 justify-center">
            <button
              onClick={handleEdit}
              className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors inline-flex items-center justify-center"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 w-5 mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                />
              </svg>
              Edit
            </button>
          </div>
        </div>
      )}

      <div className="space-y-6 mb-8">
        {quotation?.cards?.length > 0 ? (
          quotation.cards.map((card, index) => (
            <div
              key={index}
              className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden"
            >
              <div className="bg-gray-50 px-4 py-2 border-b border-gray-200">
                <h3 className="font-medium text-gray-700">
                  {card.type || "No Type"}{" "}
                  {card.size && (
                    <span className="text-sm font-normal text-gray-500 ml-2">
                      Size: {card.size}
                    </span>
                  )}
                </h3>
              </div>
              <div className="p-4">
                {card.items?.length > 0 ? (
                  card.items.map((item, itemIndex) => (
                    <div key={itemIndex} className="mb-4 last:mb-0">
                      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between">
                        <div className="flex-grow mb-4 sm:mb-0">
                          <h4 className="font-semibold text-lg text-gray-800">
                            {item.article}
                            {item.cat1 && ` - ${item.cat1}`}
                            {item.cat2 && `, ${item.cat2}`}
                            {item.cat3 && `, ${item.cat3}`}
                          </h4>
                        </div>
                        <div className="w-full sm:w-auto">
                          <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                            <div className="space-y-2">
                              <div className="flex justify-between text-sm text-gray-600">
                                <span>Unit Price:</span>
                                <span>
                                  ₹{parseFloat(item.final_price).toFixed(2)}
                                </span>
                              </div>
                              <div className="flex justify-between text-sm text-gray-600">
                                <span>Quantity:</span>
                                <span>{item.quantity}</span>
                              </div>
                              <div className="flex justify-between text-sm text-gray-600">
                                <span>Margin:</span>
                                <span>{getMarginForItem(item.mc_name)}%</span>
                              </div>
                              <div className="border-t border-gray-300 pt-2 mt-2">
                                <div className="flex justify-between font-bold text-orange-600">
                                  <span>Total:</span>
                                  <span>
                                    ₹
                                    {(item.final_price * item.quantity).toFixed(
                                      2
                                    )}
                                  </span>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="text-gray-500 text-center py-4">
                    No items in this card.
                  </p>
                )}
              </div>
            </div>
          ))
        ) : (
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
            <p className="text-gray-500">No quotation data available</p>
          </div>
        )}
      </div>

      {quotation?.cards?.length > 0 && (
        <div className="bg-white p-4 sm:p-6 border-t border-gray-200 shadow-sm mt-6">
          <div className="max-w-full mx-auto">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-gray-700">
                Grand Total
              </h3>
              <p className="text-xl font-bold text-orange-600">
                ₹{calculateGrandTotal()}
              </p>
            </div>
            {!isConfirmed && (
              <div className="flex flex-row sm:gap-4 gap-1 justify-end">
                <button
                  onClick={handleSaveAndExit}
                  className="px-6 py-3 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors shadow-sm font-medium w-full"
                >
                  Save and Exit
                </button>
                <button
                  onClick={() => setIsModalOpen(true)}
                  className="px-6 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full"
                >
                  Confirm
                </button>
              </div>
            )}
          </div>
        </div>
      )}

      <ConfirmationModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onConfirm={handleConfirmAction}
      />
    </div>
  );
};

export default Preview;