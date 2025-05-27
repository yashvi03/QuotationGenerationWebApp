import { useEffect, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
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
  const [notification, setNotification] = useState(null);
  const navigate = useNavigate();
  const [PDF, setPDF] = useState(null);
  const location = useLocation();

  // const quotationId = localStorage.getItem("quotationId");
  const quotationId = location.state?.quotationId;
  console.log("preview qid", quotationId);

  // if(!quotationId.includes('WIP'))
  //   setIsConfirmed(true)

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
        console.log(response.data);
        setQuotation(response.data);
        if (!quotationId.startsWith("WIP_")) {
          setIsConfirmed(true);
        }
      } catch (error) {
        setError(error.message || "Error fetching quotation");
        console.error("Error fetching quotation:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchQuotation();
  }, [quotationId]);

  // Function to show notification
  const showNotification = (message, type = 'success') => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 3000);
  };

  // Function to get margin based on mc_name
  const getMarginForItem = (mcName) => {
    if (!quotation?.margins || !mcName) return 0;
    const marginObj = quotation.margins.find(
      (margin) => margin.mc_name === mcName
    );
    return marginObj ? marginObj.margin : 0;
  };

  // Function to calculate total of all items
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

  const handleDownload = useCallback(
    async (finalQuotationId) => {
      
        try {
          const response = await axiosInstance.post(
            `/download_pdf/${finalQuotationId}`,
            {
              tableData: quotation.cards,
              customer: quotation.customer,
            },
            { responseType: "blob" }
          );

          const blob = new Blob([response.data], { type: "application/pdf" });
          const url = window.URL.createObjectURL(blob);

          const link = document.createElement("a");
          link.href = url;
          link.setAttribute("download", `quotation_${finalQuotationId}.pdf`);
          document.body.appendChild(link);
          link.click();
          link.remove();

          // Don't open in new tab, just show notification
          showNotification("Your PDF is ready and has been downloaded!");

          return url;
        } catch (error) {
          setError(error.message || "Error downloading PDF");
          console.error("Error downloading PDF:", error);
        }
      },
    [quotation, PDF]
  );

  const handleConfirmAction = useCallback(async () => {
    if (!quotation) return;

    try {
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
      // Get the quotation ID from the response (could be new or existing)
      const confirmedQuotationId =
        response.data.quotation_id || finalQuotationId;

      // Delete the WIP version regardless
      await axiosInstance.delete(`/delete_quotation/${quotationId}`);

      // Fetch the final quotation (new or existing)
      const quotationResponse = await axiosInstance.get(
        `/preview_final_quotation/${confirmedQuotationId}`
      );
      setQuotation(quotationResponse.data);

      const pdf = await handleDownload(confirmedQuotationId);
      setPDF(pdf);

      setIsModalOpen(false);
      setIsConfirmed(true);
      localStorage.setItem("quotationId", confirmedQuotationId);
    } catch (error) {
      setError(
        error.message || "Error confirming quotation or downloading PDF"
      );
      console.error("Error:", error);
    }
  }, [quotation, quotationId, handleDownload]);

  const handleEdit = useCallback(async () => {
    console.log(quotation);
    const payload = {
      customer_id: quotation.customer.customer_id,
      card_ids: quotation.cards.map((card) => card.card_id),
      margin_ids: quotation.margins.map((margin) => margin.margin_id),
    };
    const response = await editFinalQuotation(payload);
    // console.log(response)
    navigate("/home", { state: { quotationId: response.data.quotation_id } });
    console.log("hehhrhe", response.quotation_id);
    // navigate("/home", { state: { quotationId: result.quotation_id } });
  }, [navigate, quotation]);

  const handleShare = useCallback(async () => {
    if (!quotationId || !quotation) return;

    try {
      let file;
      if (PDF) {
        const response = await fetch(PDF);
        const blob = await response.blob();
        file = new File([blob], `quotation_${quotationId}.pdf`, {
          type: "application/pdf",
        });
      } else {
        const response = await axiosInstance.post(
          `/download_pdf/${quotationId}`,
          {
            tableData: { cards: quotation.cards },
            customer: quotation.customer,
          },
          { responseType: "blob" }
        );
        const fileBlob = new Blob([response.data], { type: "application/pdf" });
        file = new File([fileBlob], `quotation_${quotationId}.pdf`, {
          type: "application/pdf",
        });
      }

      if (navigator.canShare && navigator.canShare({ files: [file] })) {
        await navigator.share({
          title: "Quotation PDF",
          text: "Here is your quotation document.",
          files: [file],
        });
      } else {
        showNotification("File sharing is not supported on this device.", "error");
      }
    } catch (error) {
      console.error("Error sharing quotation:", error);
      showNotification("Failed to share the quotation.", "error");
    }
  }, [quotationId, quotation, PDF]);

  // SVG Icons
  const EditIcon = () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
      <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
    </svg>
  );

  const DownloadIcon = () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
      <polyline points="7,10 12,15 17,10"/>
      <line x1="12" x2="12" y1="15" y2="3"/>
    </svg>
  );

  const ShareIcon = () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="18" cy="5" r="3"/>
      <circle cx="6" cy="12" r="3"/>
      <circle cx="18" cy="19" r="3"/>
      <line x1="8.59" x2="15.42" y1="13.51" y2="17.49"/>
      <line x1="15.41" x2="8.59" y1="6.51" y2="10.49"/>
    </svg>
  );

  if (isLoading) {
    return <div className="p-4 sm:p-6 text-gray-600">Loading...</div>;
  }

  if (error) {
    return <div className="p-4 sm:p-6 text-red-500">Error: {error}</div>;
  }

  const finalQuotationId = quotationId.replace("WIP_", "");

  return (
    <div className="p-4 sm:p-6 max-w-4xl mx-auto bg-gray-100 min-h-screen">
      {/* Notification */}
      {notification && (
        <div className={`fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${
          notification.type === 'success' 
            ? 'bg-green-500 text-white' 
            : 'bg-red-500 text-white'
        }`}>
          {notification.message}
        </div>
      )}

      {/* Quotation Header */}
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

      {/* Cards Section */}
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

      {/* Grand Total Section */}
      {quotation?.cards?.length > 0 && (
        <div className="bg-white p-4 sm:p-6 rounded-lg shadow-sm border border-gray-200 mb-8">
          <div className="flex justify-between items-center">
            <h3 className="text-lg font-semibold text-gray-700">Grand Total</h3>
            <p className="text-xl font-bold text-orange-600">
              ₹{calculateGrandTotal()}
            </p>
          </div>
        </div>
      )}

      {/* Action Buttons */}
      <div className="flex flex-row sm:gap-4 gap-1 justify-end sticky bottom-6 bg-gray-100 pt-4">
        {isConfirmed ? (
          <>
            <button
              onClick={handleEdit}
              className="flex items-center gap-2 sm:px-6 px-2 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors shadow-sm font-medium w-full sm:w-auto justify-center"
            >
              <EditIcon />
              <span className="hidden sm:inline">Edit</span>
            </button>
            <button
              onClick={() => handleDownload(finalQuotationId)}
              className="flex items-center gap-2 sm:px-6 px-2 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full sm:w-auto justify-center"
            >
              <DownloadIcon />
              <span className="hidden sm:inline">Download</span>
            </button>
            <button
              onClick={handleShare}
              className="flex items-center gap-2 sm:px-6 px-2 py-3 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors shadow-sm font-medium w-full sm:w-auto justify-center"
            >
              <ShareIcon />
              <span className="hidden sm:inline">Share</span>
            </button>
          </>
        ) : (
          <>
            <button
              onClick={handleSaveAndExit}
              className="px-6 py-3 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors shadow-sm font-medium w-full sm:w-auto"
            >
              Save and Exit
            </button>
            <button
              onClick={() => setIsModalOpen(true)}
              className="px-6 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
            >
              Confirm
            </button>
          </>
        )}
      </div>

      <ConfirmationModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onConfirm={handleConfirmAction}
      />
    </div>
  );
};

export default Preview;