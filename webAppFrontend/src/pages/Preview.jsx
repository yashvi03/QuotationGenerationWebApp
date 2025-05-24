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
  const navigate = useNavigate();
  const [pdfBlob, setPdfBlob] = useState(null);
  const [pdfUrl, setPdfUrl] = useState(null);
  const [pdfError, setPdfError] = useState(null);
  const [isGeneratingPdf, setIsGeneratingPdf] = useState(false);
  const [isSharing, setIsSharing] = useState(false);
  const [isDownloading, setIsDownloading] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  const [showPdfViewer, setShowPdfViewer] = useState(false);
  const location = useLocation();
  const { id } = useParams();
  const pdfGeneratedRef = useRef(false);

  // Mobile detection effect
  useEffect(() => {
    const checkMobile = () => {
      const userAgent = navigator.userAgent.toLowerCase();
      const mobileKeywords = [
        "mobile",
        "android",
        "iphone",
        "ipad",
        "ipod",
        "blackberry",
        "windows phone",
      ];
      const isMobileDevice =
        mobileKeywords.some((keyword) => userAgent.includes(keyword)) ||
        window.innerWidth <= 768;
      setIsMobile(isMobileDevice);
    };

    checkMobile();
    window.addEventListener("resize", checkMobile);
    return () => window.removeEventListener("resize", checkMobile);
  }, []);

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
    [pdfUrl, isGeneratingPdf, quotation]
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
      } catch (error) {
        setError(error.message || "Error fetching quotation");
        console.error("Error fetching quotation:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchQuotation();
  }, [quotationId]);

  useEffect(() => {
    if (
      isConfirmed &&
      quotation &&
      quotation.cards?.length &&
      quotation.customer &&
      !pdfGeneratedRef.current &&
      !quotationId.startsWith("WIP_")
    ) {
      pdfGeneratedRef.current = true;
      const timer = setTimeout(() => {
        console.log("Triggering PDF generation for quotation:", quotationId);
        handleGeneratePDF(quotationId);
      }, 500);
      return () => clearTimeout(timer);
    } else {
      console.log("Skipping PDF generation", {
        isConfirmed,
        hasQuotation: !!quotation,
        hasCards: !!quotation?.cards?.length,
        hasCustomer: !!quotation?.customer,
        pdfGenerated: pdfGeneratedRef.current,
        isWip: quotationId.startsWith("WIP_"),
      });
    }
  }, [isConfirmed, quotation, quotationId, handleGeneratePDF]);

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

  const handleDownload = useCallback(async () => {
    if (!pdfUrl || !pdfBlob) {
      console.error("Cannot download: PDF URL or blob not available");
      alert("PDF not ready. Please try regenerating the PDF.");
      return;
    }

    try {
      setIsDownloading(true);
      console.log("Starting download...");

      const link = document.createElement("a");
      link.href = pdfUrl;
      link.setAttribute(
        "download",
        `quotation_${quotationId.replace("WIP_", "")}.pdf`
      );

      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      console.log("PDF download initiated");

      setTimeout(() => {
        setIsDownloading(false);
      }, 2000);
    } catch (err) {
      console.error("Download failed:", err);
      setIsDownloading(false);
      alert("Download failed. Please try again.");
    }
  }, [pdfUrl, pdfBlob, quotationId]);

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

      pdfGeneratedRef.current = false;
      setIsModalOpen(false);
      setIsConfirmed(true);
      localStorage.setItem("quotationId", confirmedQuotationId);
      navigate(`/preview/${confirmedQuotationId}`, { replace: true });
    } catch (error) {
      setError(error.message || "Error confirming quotation");
      console.error("Error:", error);
    } finally {
      setIsLoading(false);
    }
  }, [quotation, quotationId, navigate]);

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

  const handleShare = useCallback(async () => {
    if (!quotationId || !quotation || !pdfBlob) {
      console.error("Cannot share: missing required data", {
        hasQuotationId: !!quotationId,
        hasQuotation: !!quotation,
        hasPdfBlob: !!pdfBlob,
      });
      alert("PDF not ready. Please try generating the PDF first.");
      return;
    }

    try {
      setIsSharing(true);
      console.log("Starting share process...");

      // Check if Web Share API is available and supports files
      if (navigator.share && navigator.canShare) {
        const fileName = `quotation_${quotationId.replace("WIP_", "")}.pdf`;
        const file = new File([pdfBlob], fileName, { type: "application/pdf" });

        if (navigator.canShare({ files: [file] })) {
          try {
            await navigator.share({
              title: `Quotation ${quotationId.replace("WIP_", "")}`,
              text: `Please find attached the quotation for ${quotation.customer.name}`,
              files: [file],
            });
            console.log("File shared successfully via Web Share API");
            return;
          } catch (shareError) {
            console.log(
              "Web Share API failed, falling back to WhatsApp:",
              shareError
            );
          }
        }
      }

      // Fallback to WhatsApp sharing
      const customerPhone =
        quotation.customer.whatsapp_number || quotation.customer.phone_number;
      if (!customerPhone) {
        throw new Error(
          "Customer phone number not found. Please add a phone number to the customer profile."
        );
      }

      const cleanPhone = customerPhone.replace(/\D/g, "");
      if (cleanPhone.length < 10) {
        throw new Error("Invalid phone number. Must be at least 10 digits.");
      }

      const formData = new FormData();
      const file = new File(
        [pdfBlob],
        `quotation_${quotationId.replace("WIP_", "")}.pdf`,
        { type: "application/pdf" }
      );
      formData.append("file", file);
      formData.append("phone_number", cleanPhone);

      console.log("Uploading PDF for WhatsApp sharing:", {
        fileName: file.name,
        fileSize: file.size,
        phoneNumber: cleanPhone ? `***${cleanPhone.slice(-4)}` : "none",
      });

      const uploadResponse = await axiosInstance.post(
        "/upload-quotation",
        formData,
        {
          headers: {
            "Content-Type": "multipart/form-data",
          },
          timeout: 30000,
        }
      );

      console.log("Upload response:", uploadResponse.data);

      if (uploadResponse.data.message !== "File uploaded successfully!") {
        throw new Error(uploadResponse.data.error || "Failed to upload PDF.");
      }

      alert("Quotation shared successfully via WhatsApp!");
    } catch (error) {
      console.error("Error sharing quotation:", error);
      let errorMessage = "Failed to share the quotation. ";
      if (error.code === "ECONNABORTED" || error.message.includes("timeout")) {
        errorMessage +=
          "The operation timed out. Please check your internet connection.";
      } else if (error.message.includes("No file uploaded")) {
        errorMessage += "No PDF file was uploaded. Please regenerate the PDF.";
      } else if (error.message.includes("Phone number is required")) {
        errorMessage += "Please provide a valid customer phone number.";
      } else if (error.message.includes("Invalid phone number")) {
        errorMessage +=
          "The phone number is invalid. Please check and try again.";
      } else if (error.response) {
        errorMessage +=
          error.response.data?.error ||
          `Server error: ${error.response.status}`;
      } else {
        errorMessage += error.message;
      }
      alert(errorMessage);
    } finally {
      setIsSharing(false);
    }
  }, [quotationId, quotation, pdfBlob]);

  const handleRegeneratePDF = () => {
    if (quotationId) {
      pdfGeneratedRef.current = false;
      handleGeneratePDF(quotationId);
    }
  };

  // Mobile PDF view handler - now opens in the same app
  const handleMobilePdfView = () => {
    if (pdfUrl) {
      setShowPdfViewer(true);
    }
  };

  const handleClosePdfViewer = () => {
    setShowPdfViewer(false);
  };

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

  // Mobile PDF Viewer Modal
  if (showPdfViewer && isMobile && pdfUrl) {
    return (
      <div className="fixed inset-0 bg-white z-50 flex flex-col">
        <div className="flex items-center justify-between p-4 bg-orange-600 text-white">
          <h2 className="text-lg font-semibold">PDF Viewer</h2>
          <button
            onClick={handleClosePdfViewer}
            className="p-2 hover:bg-orange-700 rounded-md transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </div>
        <div className="flex-1 overflow-hidden">
          <object
            data={pdfUrl}
            type="application/pdf"
            width="100%"
            height="100%"
            className="w-full h-full"
          >
            <div className="flex flex-col items-center justify-center h-full p-4">
              <p className="text-red-500 text-center mb-4">
                Your browser cannot display the PDF directly.
              </p>
              <button
                onClick={handleDownload}
                className="px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors"
              >
                Download PDF
              </button>
            </div>
          </object>
        </div>
        <div className="p-4 bg-gray-50 border-t flex gap-2">
          <button
            onClick={handleDownload}
            disabled={isDownloading}
            className="flex-1 px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors disabled:opacity-50"
          >
            {isDownloading ? "Downloading..." : "Download"}
          </button>
          <button
            onClick={handleShare}
            disabled={isSharing}
            className="flex-1 px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors disabled:opacity-50"
          >
            {isSharing ? "Sharing..." : "Share"}
          </button>
        </div>
      </div>
    );
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
            <h2 className="text-xl font-semibold text-gray-700">PDF Preview</h2>
            <div className="flex gap-2">
              <button
                onClick={handleDownload}
                disabled={isDownloading}
                className="px-3 py-1 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors inline-flex items-center justify-center text-sm disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isDownloading ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-t-2 border-b-2 border-white mr-1"></div>
                    Downloading...
                  </>
                ) : (
                  <>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      className="h-4 w-4 mr-1"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                      />
                    </svg>
                    Download
                  </>
                )}
              </button>
            </div>
          </div>

          {isDownloading && (
            <div className="mb-4 p-3 bg-blue-50 border border-blue-200 rounded-md">
              <div className="flex items-center">
                <div className="animate-spin rounded-full h-4 w-4 border-t-2 border-b-2 border-blue-600 mr-2"></div>
                <span className="text-blue-700 text-sm">
                  Preparing download... Please wait.
                </span>
              </div>
            </div>
          )}

          <div
            className="pdf-container border border-gray-300 rounded-lg overflow-hidden"
            style={{ minHeight: "500px", width: "100%" }}
          >
            {pdfError ? (
              <div className="text-center py-10 text-red-500">
                <p>{pdfError}</p>
                <button
                  onClick={handleRegeneratePDF}
                  className="mt-4 px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors"
                >
                  Regenerate PDF
                </button>
              </div>
            ) : pdfUrl ? (
              <>
                {isMobile ? (
                  // Mobile view - show button to open PDF in same app
                  <div className="text-center py-20 bg-gray-50">
                    <div className="mb-4">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-16 w-16 mx-auto text-orange-600 mb-4"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={1}
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                        />
                      </svg>
                    </div>
                    <h3 className="text-lg font-semibold text-gray-700 mb-2">
                      PDF Ready to View
                    </h3>
                    <p className="text-gray-600 mb-6 text-sm">
                      Tap the button below to view your PDF
                    </p>
                    <button
                      onClick={handleMobilePdfView}
                      className="px-6 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors inline-flex items-center justify-center font-medium"
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
                          d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                        />
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                        />
                      </svg>
                      View PDF
                    </button>
                  </div>
                ) : (
                  // Desktop view - embed PDF
                  <object
                    data={pdfUrl}
                    type="application/pdf"
                    width="100%"
                    height="600px"
                    className="rounded-lg"
                  >
                    <p className="text-red-500 text-center py-4">
                      Your browser cannot display the PDF.{" "}
                      <a href={pdfUrl} download>
                        Download it instead
                      </a>
                      .
                    </p>
                  </object>
                )}
              </>
            ) : (
              <div className="text-center py-10">
                <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-orange-600 mx-auto"></div>
                <p className="mt-2">
                  {isGeneratingPdf
                    ? "Generating PDF..."
                    : "Preparing PDF viewer..."}
                </p>
              </div>
            )}
          </div>
          <div className="mt-4 flex gap-2 justify-center">
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
            <button
              onClick={handleShare}
              disabled={isSharing || !pdfBlob}
              className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors inline-flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isSharing ? (
                <div className="animate-spin rounded-full h-4 w-4 border-t-2 border-b-2 border-white mr-2"></div>
              ) : (
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
                    d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.68 3 3 0 00-5.367 2.68zm0 9.316a3 3 0 105.368 2.68 3 3 0 00-5.368-2.68z"
                  />
                </svg>
              )}
              {isSharing ? "Sharing..." : "Share via WhatsApp"}
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
