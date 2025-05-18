
import { useEffect, useState, useCallback, useMemo } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import axiosInstance from "../services/axiosInstance";
import "../App.css";
import ConfirmationModal from "../components/ConfirmationModel";
import { editFinalQuotation } from "../services/api";
import { Document, Page, pdfjs } from "react-pdf";
import "react-pdf/dist/esm/Page/AnnotationLayer.css";
import "react-pdf/dist/esm/Page/TextLayer.css";

// Configure PDF.js worker with fallback mechanisms - FIX: Use unpkg instead of cdnjs
pdfjs.GlobalWorkerOptions.workerSrc = `https://unpkg.com/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.js`;
// Backup fallback to avoid network issues
if (typeof window !== 'undefined') {
  window.pdfjsWorkerSrc = pdfjs.GlobalWorkerOptions.workerSrc;
}

const Preview = () => {
  const [quotation, setQuotation] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [isConfirmed, setIsConfirmed] = useState(false);
  const navigate = useNavigate();
  const [pdfBlob, setPdfBlob] = useState(null);
  const [pdfUrl, setPdfUrl] = useState(null);
  const [numPages, setNumPages] = useState(null);
  const [pageNumber, setPageNumber] = useState(1);
  const [showPdf, setShowPdf] = useState(false);
  const [pdfError, setPdfError] = useState(null);
  const location = useLocation();

  const quotationId = location.state?.quotationId;
  console.log("preview qid", quotationId);

  // PDF.js options for cMaps - FIX: Use unpkg instead of cdnjs
  const pdfOptions = useMemo(
    () => ({
      cMapUrl: `https://unpkg.com/pdfjs-dist@${pdfjs.version}/cmaps/`,
      cMapPacked: true,
      standardFontDataUrl: `https://unpkg.com/pdfjs-dist@${pdfjs.version}/standard_fonts/`,
      // Enable the built-in worker which will work even if external worker fails
      enableXfa: false,
      disableStream: true, // Changed to true to avoid streaming issues
      disableAutoFetch: true,
      disableRange: true
    }),
    []
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

  const onDocumentLoadSuccess = ({ numPages }) => {
    setNumPages(numPages);
    setPageNumber(1);
    setPdfError(null);
  };

  const onDocumentLoadError = (error) => {
    console.error("Error loading PDF:", error);
    setPdfError(`Failed to load PDF: ${error.message}`);
    
    // Try to use a backup rendering approach
    tryBackupPdfRendering();
  };
  
  // New function to try backup PDF rendering methods
  const tryBackupPdfRendering = () => {
    if (pdfBlob) {
      // Try to create a different URL from the blob
      try {
        const backupUrl = window.URL.createObjectURL(
          new Blob([pdfBlob], { type: 'application/pdf' })
        );
        console.log("Using backup PDF URL:", backupUrl);
        setPdfUrl(backupUrl);
      } catch (e) {
        console.error("Backup URL creation failed:", e);
      }
    }
  };

  const changePage = (offset) => {
    setPageNumber((prevPageNumber) => {
      const newPageNumber = prevPageNumber + offset;
      return Math.max(1, Math.min(numPages, newPageNumber));
    });
  };

  const previousPage = () => changePage(-1);
  const nextPage = () => changePage(1);

  const handleGeneratePDF = useCallback(
    async (finalQuotationId) => {
      try {
        setIsLoading(true);
        setPdfError(null);
        
        const response = await axiosInstance.post(
          `/download_pdf/${finalQuotationId}`,
          {
            tableData: quotation.cards,
            customer: quotation.customer,
          },
          { responseType: "blob" }
        );

        console.log("PDF API response:", response);
        if (!response.data || response.data.size === 0) {
          throw new Error("Received empty PDF from server");
        }
        
        // Create a blob from the response data
        const blob = new Blob([response.data], { type: "application/pdf" });
        console.log("PDF Blob:", blob);
        setPdfBlob(blob);

        // Revoke previous URL if exists to prevent memory leaks
        if (pdfUrl) {
          window.URL.revokeObjectURL(pdfUrl);
        }
        
        // Create URL directly from blob
        const url = window.URL.createObjectURL(blob);
        console.log("PDF URL:", url);
        setPdfUrl(url);
        setShowPdf(true);
        
        // Alternative approach using FileReader (for debugging purposes)
        try {
          const reader = new FileReader();
          reader.onload = function(e) {
            console.log("FileReader loaded PDF data as Data URL");
            // We don't use the data URL for rendering, just confirming the PDF can be read
          };
          reader.readAsDataURL(blob);
        } catch (e) {
          console.error("FileReader fallback error:", e);
        }
        
        setIsLoading(false);
        return url;
      } catch (error) {
        setPdfError(error.message || "Error generating PDF");
        setError(error.message || "Error generating PDF");
        console.error("Error generating PDF:", error);
        setIsLoading(false);
        return null;
      }
    },
    [quotation, pdfUrl]
  );

  const handleDownload = useCallback(() => {
    if (!pdfUrl || !pdfBlob) return;

    const link = document.createElement("a");
    link.href = pdfUrl;
    link.setAttribute(
      "download",
      `quotation_${quotationId.replace("WIP_", "")}.pdf`
    );
    document.body.appendChild(link);
    link.click();
    link.remove();
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
      setQuotation(quotationResponse.data);

      await handleGeneratePDF(confirmedQuotationId);

      setIsModalOpen(false);
      setIsConfirmed(true);
      localStorage.setItem("quotationId", confirmedQuotationId);
    } catch (error) {
      setError(error.message || "Error confirming quotation or generating PDF");
      console.error("Error:", error);
    } finally {
      setIsLoading(false);
    }
  }, [quotation, quotationId, handleGeneratePDF]);

  const handleEdit = useCallback(async () => {
    console.log("Quotation for edit:", quotation);
    try {
      setIsLoading(true);
      const payload = {
        customer_id: quotation.customer.customer_id,
        card_ids: quotation.cards.map((card) => card.card_id),
        margin_ids: quotation.margins.map((margin) => margin.margin_id),
      };
      const response = await editFinalQuotation(payload);
      navigate("/home", { state: { quotationId: response.data.quotation_id } });
      console.log("Edit response quotation_id:", response.data.quotation_id);
    } catch (error) {
      setError(error.message || "Error editing quotation");
      console.error("Error editing quotation:", error);
    } finally {
      setIsLoading(false);
    }
  }, [navigate, quotation]);

  const handleShare = useCallback(async () => {
    if (!quotationId || !quotation || !pdfBlob) return;

    try {
      const file = new File(
        [pdfBlob],
        `quotation_${quotationId.replace("WIP_", "")}.pdf`,
        {
          type: "application/pdf",
        }
      );

      if (navigator.canShare && navigator.canShare({ files: [file] })) {
        await navigator.share({
          title: "Quotation PDF",
          text: "Here is your quotation document.",
          files: [file],
        });
      } else {
        alert("File sharing is not supported on this device.");
      }
    } catch (error) {
      console.error("Error sharing quotation:", error);
      alert("Failed to share the quotation.");
    }
  }, [quotationId, quotation, pdfBlob]);

  // For direct PDF rendering via an iframe as fallback
  const [useIframeViewer, setUseIframeViewer] = useState(false);

  const togglePdfView = useCallback(async () => {
    console.log("Toggling PDF view, quotationId:", quotationId);
    if (showPdf) {
      setShowPdf(false);
    } else {
      try {
        if (!pdfUrl) {
          await handleGeneratePDF(quotationId.replace("WIP_", ""));
        } else {
          setShowPdf(true);
        }
      } catch (error) {
        console.error("Error toggling PDF view:", error);
      }
    }
  }, [showPdf, pdfUrl, handleGeneratePDF, quotationId]);

  // Add a direct iframe view option as ultimate fallback
  const renderPdfWithIframe = () => {
    if (!pdfUrl) return null;
    
    return (
      <iframe 
        src={pdfUrl} 
        title="PDF Viewer" 
        className="w-full" 
        style={{ height: "600px", border: "none" }}
      />
    );
  };

  // Clean up PDF URL on unmount
  useEffect(() => {
    return () => {
      if (pdfUrl) {
        window.URL.revokeObjectURL(pdfUrl);
      }
    };
  }, [pdfUrl]);

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

      {/* PDF Viewer Section */}
      {showPdf && (
        <div className="mb-6 bg-white p-4 rounded-lg shadow-sm border border-gray-200">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-semibold text-gray-700">PDF Preview</h2>
            <div>
              {pdfError && (
                <button
                  onClick={() => setUseIframeViewer(!useIframeViewer)}
                  className="px-3 py-1 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors mr-2"
                >
                  {useIframeViewer ? "Try React-PDF Viewer" : "Try Basic PDF Viewer"}
                </button>
              )}
              <button
                onClick={togglePdfView}
                className="px-3 py-1 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors"
              >
                Close PDF
              </button>
            </div>
          </div>

          <div
            className="pdf-container border border-gray-300 rounded-lg overflow-hidden"
            style={{ minHeight: "500px", width: "100%" }}
          >
            {pdfError && useIframeViewer ? (
              renderPdfWithIframe()
            ) : pdfError ? (
              <div className="text-center py-10 text-red-500">
                <p>{pdfError}</p>
                <div className="mt-4 space-x-2">
                  <button
                    onClick={() => handleGeneratePDF(quotationId.replace("WIP_", ""))}
                    className="px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors"
                  >
                    Regenerate PDF
                  </button>
                  <button
                    onClick={() => setUseIframeViewer(true)}
                    className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
                  >
                    Try Simple Viewer
                  </button>
                </div>
              </div>
            ) : pdfUrl ? (
              <Document
                file={pdfUrl}
                options={pdfOptions}
                onLoadSuccess={onDocumentLoadSuccess}
                onLoadError={onDocumentLoadError}
                loading={
                  <div className="text-center py-10">
                    <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-orange-600 mx-auto"></div>
                    <p className="mt-2">Loading PDF...</p>
                  </div>
                }
                error={
                  <div className="text-center py-10 text-red-500">
                    <p>Failed to load PDF. This may be due to:</p>
                    <ul className="list-disc list-inside my-2 text-left max-w-md mx-auto">
                      <li>Network connectivity issues</li>
                      <li>PDF.js worker loading problems</li>
                      <li>Invalid PDF document</li>
                    </ul>
                    <div className="mt-4 space-x-2">
                      <button
                        onClick={() => setUseIframeViewer(true)}
                        className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
                      >
                        Try Simple Viewer
                      </button>
                      <button
                        onClick={() => handleGeneratePDF(quotationId.replace("WIP_", ""))}
                        className="px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors"
                      >
                        Regenerate PDF
                      </button>
                    </div>
                  </div>
                }
              >
                <Page 
                  pageNumber={pageNumber} 
                  renderTextLayer={false} // Set to false for better performance
                  renderAnnotationLayer={false} // Set to false for better performance
                  scale={1.0}
                />
              </Document>
            ) : (
              <div className="text-center py-10">
                <p>Preparing PDF viewer...</p>
              </div>
            )}
          </div>
          
          {numPages && numPages > 1 && !useIframeViewer && (
            <div className="flex justify-between items-center mt-4">
              <button
                onClick={previousPage}
                disabled={pageNumber <= 1}
                className={`px-4 py-2 ${
                  pageNumber <= 1
                    ? "bg-gray-300 cursor-not-allowed"
                    : "bg-orange-600 hover:bg-orange-700"
                } text-white rounded-md transition-colors`}
              >
                Previous
              </button>
              <p className="text-gray-600">
                Page {pageNumber} of {numPages}
              </p>
              <button
                onClick={nextPage}
                disabled={pageNumber >= numPages}
                className={`px-4 py-2 ${
                  pageNumber >= numPages
                    ? "bg-gray-300 cursor-not-allowed"
                    : "bg-orange-600 hover:bg-orange-700"
                } text-white rounded-md transition-colors`}
              >
                Next
              </button>
            </div>
          )}
        </div>
      )}

      {/* Cards Section */}
      {(!showPdf || isConfirmed) && (
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
                                      {(
                                        item.final_price * item.quantity
                                      ).toFixed(2)}
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
      )}

      {/* Grand Total Section */}
      {(!showPdf || isConfirmed) && quotation?.cards?.length > 0 && (
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
              className="sm:px-6 px-2 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading}
            >
              Edit
            </button>
            <button
              onClick={togglePdfView}
              className="sm:px-6 px-2 py-3 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading}
            >
              {showPdf ? "Hide PDF" : "View PDF"}
            </button>
            <button
              onClick={handleDownload}
              className="sm:px-6 px-2 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading || !pdfUrl}
            >
              Download
            </button>
            <button
              onClick={handleShare}
              className="sm:px-6 px-2 py-3 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading || !pdfUrl}
            >
              Share
            </button>
          </>
        ) : (
          <>
            <button
              onClick={handleSaveAndExit}
              className="px-6 py-3 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading}
            >
              Save and Exit
            </button>
            <button
              onClick={() => setIsModalOpen(true)}
              className="px-6 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full sm:w-auto"
              disabled={isLoading}
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