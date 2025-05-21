// import { useEffect, useState, useCallback } from "react";
// import { useNavigate, useLocation } from "react-router-dom";
// import axiosInstance from "../services/axiosInstance";
// import "../App.css";
// import ConfirmationModal from "../components/ConfirmationModel";

// const Preview = () => {
//   const [quotation, setQuotation] = useState(null);
//   const [isModalOpen, setIsModalOpen] = useState(false);
//   const [isLoading, setIsLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [isConfirmed, setIsConfirmed] = useState(false);
//   const navigate = useNavigate();
//   const [pdfBlob, setPdfBlob] = useState(null);
//   const [pdfUrl, setPdfUrl] = useState(null);
//   const [pdfError, setPdfError] = useState(null);
//   const [isGeneratingPdf, setIsGeneratingPdf] = useState(false);
//   const location = useLocation();

//   const quotationId = location.state?.quotationId;
//   console.log("Preview quotationId:", quotationId);

//   useEffect(() => {
//     if (!quotationId) {
//       setError("No quotation ID found");
//       setIsLoading(false);
//       return;
//     }

//     const fetchQuotation = async () => {
//       try {
//         let response;
//         if (quotationId.startsWith("WIP_")) {
//           response = await axiosInstance.get(`/preview_quotation/${quotationId}`);
//         } else {
//           response = await axiosInstance.get(`/preview_final_quotation/${quotationId}`);
//         }
//         if (!response.data) throw new Error("No data received");
//         console.log("Quotation data:", response.data);
//         setQuotation(response.data);
//         if (!quotationId.startsWith("WIP_")) {
//           setIsConfirmed(true);
//           setTimeout(() => handleGeneratePDF(quotationId), 500);
//         }
//       } catch (error) {
//         setError(error.message || "Error fetching quotation");
//         console.error("Error fetching quotation:", error);
//       } finally {
//         setIsLoading(false);
//       }
//     };

//     fetchQuotation();
//   }, [quotationId]);

//   const getMarginForItem = (mcName) => {
//     if (!quotation?.margins || !mcName) return 0;
//     const marginObj = quotation.margins.find((margin) => margin.mc_name === mcName);
//     return marginObj ? marginObj.margin : 0;
//   };

//   const calculateGrandTotal = () => {
//     if (!quotation?.cards) return 0;
//     return quotation.cards
//       .reduce((total, card) => {
//         const cardTotal = card.items.reduce((sum, item) => {
//           return sum + parseFloat(item.final_price) * item.quantity;
//         }, 0);
//         return total + cardTotal;
//       }, 0)
//       .toFixed(2);
//   };

//   const handleSaveAndExit = useCallback(() => {
//     navigate("/");
//   }, [navigate]);

//   const handleGeneratePDF = useCallback(
//     async (finalQuotationId) => {
//       if (isGeneratingPdf) {
//         console.log("PDF generation already in progress");
//         return null;
//       }

//       let attempts = 0;
//       const maxAttempts = 2;

//       const generateWithRetry = async () => {
//         attempts++;
//         console.log(`PDF generation attempt ${attempts} for quotation: ${finalQuotationId}`);

//         try {
//           setIsGeneratingPdf(true);
//           setIsLoading(true);
//           setPdfError(null);

//           const cleanQuotationId = finalQuotationId.replace("WIP_", "");
//           console.log("Sending PDF request for quotationId:", cleanQuotationId);
//           const response = await axiosInstance.post(
//             `/download_pdf/${cleanQuotationId}`,
//             {
//               tableData: quotation.cards,
//               customer: quotation.customer,
//             },
//             {
//               responseType: "blob",
//               timeout: 30000,
//             }
//           );

//           console.log("PDF API response received, size:", response.data?.size);
//           console.log("Response headers:", response.headers);
//           if (!response.data || response.data.size === 0) {
//             throw new Error("Received empty PDF from server");
//           }

//           const blob = new Blob([response.data], { type: "application/pdf" });
//           console.log("PDF Blob created, size:", blob.size);
//           console.log("Blob type:", blob.type);
//           // Log first few bytes to verify PDF header
//           const arrayBuffer = await blob.slice(0, 4).arrayBuffer();
//           const uint8Array = new Uint8Array(arrayBuffer);
//           console.log("PDF header bytes:", uint8Array);

//           setPdfBlob(blob);

//           if (pdfUrl) {
//             try {
//               window.URL.revokeObjectURL(pdfUrl);
//               console.log("Previous PDF URL revoked");
//             } catch (err) {
//               console.warn("Failed to revoke previous URL:", err);
//             }
//           }

//           const url = window.URL.createObjectURL(blob);
//           console.log("PDF URL created:", url);
//           setPdfUrl(url);
//           setPdfError(null);
//           setIsLoading(false);
//           return url;
//         } catch (error) {
//           console.error(`Error in PDF generation attempt ${attempts}:`, error);
//           if (attempts < maxAttempts) {
//             console.log(`Retrying PDF generation (attempt ${attempts + 1}/${maxAttempts})`);
//             return generateWithRetry();
//           } else {
//             setPdfError(`Error generating PDF: ${error.message}`);
//             setError(`Error generating PDF after ${maxAttempts} attempts: ${error.message}`);
//             setIsLoading(false);
//             return null;
//           }
//         } finally {
//           setIsGeneratingPdf(false);
//         }
//       };

//       return generateWithRetry();
//     },
//     [quotation, pdfUrl, isGeneratingPdf]
//   );

//   const handleDownload = useCallback(() => {
//     if (!pdfUrl || !pdfBlob) {
//       console.error("Cannot download: PDF URL or blob not available");
//       return;
//     }

//     try {
//       const link = document.createElement("a");
//       link.href = pdfUrl;
//       link.setAttribute("download", `quotation_${quotationId.replace("WIP_", "")}.pdf`);
//       document.body.appendChild(link);
//       link.click();
//       link.remove();
//       console.log("PDF download initiated");
//     } catch (err) {
//       console.error("Download failed:", err);
//       alert("Download failed. Please try again.");
//     }
//   }, [pdfUrl, pdfBlob, quotationId]);

//   const handleConfirmAction = useCallback(async () => {
//     if (!quotation) return;

//     try {
//       setIsLoading(true);
//       const finalQuotationId = quotationId.replace("WIP_", "");
//       const wipQuotation = {
//         quotation_id: finalQuotationId,
//         card_ids: quotation.cards.map((card) => card.card_id),
//         margin_ids: quotation.margins.map((margin) => margin.margin_id),
//         customer_id: quotation.customer.customer_id,
//       };

//       const response = await axiosInstance.post("/final_quotation", wipQuotation);
//       const confirmedQuotationId = response.data.quotation_id || finalQuotationId;

//       await axiosInstance.delete(`/delete_quotation/${quotationId}`);
//       const quotationResponse = await axiosInstance.get(`/preview_final_quotation/${confirmedQuotationId}`);
//       setQuotation(quotationResponse.data);

//       setTimeout(() => handleGeneratePDF(confirmedQuotationId), 800);
//       setIsModalOpen(false);
//       setIsConfirmed(true);
//       localStorage.setItem("quotationId", confirmedQuotationId);
//     } catch (error) {
//       setError(error.message || "Error confirming quotation or generating PDF");
//       console.error("Error:", error);
//     } finally {
//       setIsLoading(false);
//     }
//   }, [quotation, quotationId, handleGeneratePDF]);

//   const handleEdit = useCallback(async () => {
//     console.log("Quotation for edit:", quotation);
//     try {
//       setIsLoading(true);
//       const payload = {
//         customer_id: quotation.customer.customer_id,
//         card_ids: quotation.cards.map((card) => card.card_id),
//         margin_ids: quotation.margins.map((margin) => margin.margin_id),
//       };
//       const response = await axiosInstance.post("/edit_final_quotation", payload);
//       navigate("/home", { state: { quotationId: response.data.quotation_id } });
//       console.log("Edit response quotation_id:", response.data.quotation_id);
//     } catch (error) {
//       setError(error.message || "Error editing quotation");
//       console.error("Error editing quotation:", error);
//     } finally {
//       setIsLoading(false);
//     }
//   }, [navigate, quotation]);

//   const handleShare = useCallback(async () => {
//     if (!quotationId || !quotation || !pdfBlob) {
//       console.error("Cannot share: missing required data");
//       return;
//     }

//     try {
//       const file = new File([pdfBlob], `quotation_${quotationId.replace("WIP_", "")}.pdf`, {
//         type: "application/pdf",
//       });

//       if (navigator.canShare && navigator.canShare({ files: [file] })) {
//         await navigator.share({
//           title: "Quotation PDF",
//           text: "Here is your quotation document.",
//           files: [file],
//         });
//         console.log("Share successful");
//       } else {
//         console.warn("File sharing not supported on this device");
//         alert("File sharing is not supported on this device. You can download the file instead.");
//       }
//     } catch (error) {
//       console.error("Error sharing quotation:", error);
//       alert("Failed to share the quotation. You can try downloading instead.");
//     }
//   }, [quotationId, quotation, pdfBlob]);

//   useEffect(() => {
//     return () => {
//       if (pdfUrl) {
//         try {
//           window.URL.revokeObjectURL(pdfUrl);
//           console.log("PDF URL revoked on component unmount");
//         } catch (e) {
//           console.warn("Failed to revoke URL on unmount:", e);
//         }
//       }
//     };
//   }, [pdfUrl]);

//   if (isLoading) {
//     return (
//       <div className="p-4 sm:p-6 text-gray-600 flex justify-center items-center min-h-screen">
//         <div className="text-center">
//           <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-orange-600 mx-auto"></div>
//           <p className="mt-4">Loading...</p>
//         </div>
//       </div>
//     );
//   }

//   if (error) {
//     return <div className="p-4 sm:p-6 text-red-500">Error: {error}</div>;
//   }

//   return (
//     <div className="flex flex-col min-h-screen bg-gray-100">
//       {/* Scrollable Content */}
//       <div className="flex-1 overflow-y-auto p-4">
//         {/* Quotation Header */}
//         <div className="mb-6 bg-white p-4 sm:p-6 rounded-lg shadow-sm border border-gray-200">
//           <h1 className="text-2xl font-bold mb-6 text-orange-600 border-b pb-3">
//             Quotation Preview
//           </h1>
//           <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
//             <div className="bg-orange-50 p-4 rounded-lg border border-orange-100">
//               <p className="text-sm text-orange-700 mb-1">Quotation ID</p>
//               <p className="font-semibold text-gray-800">
//                 {quotation?.quotation_id || "N/A"}
//               </p>
//             </div>
//             <div className="bg-orange-50 p-4 rounded-lg border border-orange-100">
//               <p className="text-sm text-orange-700 mb-1">Customer</p>
//               <p className="font-semibold text-gray-800">
//                 {quotation?.customer?.name || "N/A"}
//               </p>
//             </div>
//           </div>
//         </div>

//         {/* PDF Viewer Section */}
//         {isConfirmed && (
//           <div className="mb-6 bg-white p-4 rounded-lg shadow-sm border border-gray-200">
//             <div className="flex justify-between items-center mb-4">
//               <h2 className="text-xl font-semibold text-gray-700">PDF Preview</h2>
//               {pdfUrl && (
//                 <button
//                   onClick={handleDownload}
//                   className="px-3 py-1 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors inline-flex items-center justify-center text-sm"
//                   disabled={isLoading || !pdfUrl}
//                 >
//                   <svg
//                     xmlns="http://www.w3.org/2000/svg"
//                     className="h-4 w-4 mr-1"
//                     fill="none"
//                     viewBox="0 0 24 24"
//                     stroke="currentColor"
//                   >
//                     <path
//                       strokeLinecap="round"
//                       strokeLinejoin="round"
//                       strokeWidth={2}
//                       d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
//                     />
//                   </svg>
//                   Download
//                 </button>
//               )}
//             </div>
//             <div
//               className="pdf-container border border-gray-300 rounded-lg overflow-hidden"
//               style={{ minHeight: "500px", width: "100%" }}
//             >
//               {pdfError ? (
//                 <div className="text-center py-10 text-red-500">
//                   <p>{pdfError}</p>
//                   <button
//                     onClick={() => handleGeneratePDF(quotationId)}
//                     className="mt-4 px-4 py-2 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors"
//                     disabled={isGeneratingPdf}
//                   >
//                     {isGeneratingPdf ? "Regenerating..." : "Regenerate PDF"}
//                   </button>
//                 </div>
//               ) : pdfUrl ? (
//                 <object
//                   data={pdfUrl}
//                   type="application/pdf"
//                   width="100%"
//                   height="600px"
//                   className="rounded-lg"
//                 >
//                   <p className="text-red-500 text-center py-4">
//                     Your browser cannot display the PDF.{" "}
//                     <a href={pdfUrl} download>
//                       Download it instead
//                     </a>.
//                   </p>
//                 </object>
//               ) : (
//                 <div className="text-center py-10">
//                   <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-orange-600 mx-auto"></div>
//                   <p className="mt-2">{isGeneratingPdf ? "Generating PDF..." : "Preparing PDF viewer..."}</p>
//                 </div>
//               )}
//             </div>
//             {pdfUrl && (
//               <div className="mt-4 flex gap-2 justify-center">
//                 <button
//                   onClick={handleEdit}
//                   className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors inline-flex items-center justify-center"
//                   disabled={isLoading}
//                 >
//                   <svg
//                     xmlns="http://www.w3.org/2000/svg"
//                     className="h-5 w-5 mr-2"
//                     fill="none"
//                     viewBox="0 0 24 24"
//                     stroke="currentColor"
//                   >
//                     <path
//                       strokeLinecap="round"
//                       strokeLinejoin="round"
//                       strokeWidth={2}
//                       d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
//                     />
//                   </svg>
//                   Edit
//                 </button>
//                 <button
//                   onClick={handleShare}
//                   className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors inline-flex items-center justify-center"
//                   disabled={isLoading || !pdfUrl}
//                 >
//                   <svg
//                     xmlns="http://www.w3.org/2000/svg"
//                     className="h-5 w-5 mr-2"
//                     fill="currentColor"
//                     viewBox="0 0 24 24"
//                   >
//                     <path d="M20.33 4.67a1.86 1.86 0 00-2.3-.2L9.55 9.2a4.21 4.21 0 00-1.3-.57A4.16 4.16 0 004 12.83a4.16 4.16 0 004.25 4.16 4.21 4.21 0 001.3-.57l8.48 4.73a1.86 1.86 0 002.3-.2 2.07 2.07 0 00.47-2.3L17.2 13.5l3.62-5.13a2.07 2.07 0 00-.49-2.3zM8.25 15.83A2.16 2.16 0 015.5 12.83a2.16 2.16 0 012.75-2.17c.66.15 1.2.55 1.55 1.08l1.82 2.58-1.82 2.58a2.2 2.2 0 01-1.55 1.08zm10.58 2.5a.47.47 0 01-.58.05L9.2 13.5l9.05-4.88a.47.47 0 01.58.05.67.67 0 01.15.58l-3.62 5.13 3.62 5.12a.67.67 0 01-.15.58z" />
//                   </svg>
//                   Share
//                 </button>
//               </div>
//             )}
//           </div>
//         )}

//         {/* Cards Section */}
//         <div className="space-y-6 mb-8">
//           {quotation?.cards?.length > 0 ? (
//             quotation.cards.map((card, index) => (
//               <div
//                 key={index}
//                 className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden"
//               >
//                 <div className="bg-gray-50 px-4 py-2 border-b border-gray-200">
//                   <h3 className="font-medium text-gray-700">
//                     {card.type || "No Type"}{" "}
//                     {card.size && (
//                       <span className="text-sm font-normal text-gray-500 ml-2">
//                         Size: {card.size}
//                       </span>
//                     )}
//                   </h3>
//                 </div>
//                 <div className="p-4">
//                   {card.items?.length > 0 ? (
//                     card.items.map((item, itemIndex) => (
//                       <div key={itemIndex} className="mb-4 last:mb-0">
//                         <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between">
//                           <div className="flex-grow mb-4 sm:mb-0">
//                             <h4 className="font-semibold text-lg text-gray-800">
//                               {item.article}
//                               {item.cat1 && ` - ${item.cat1}`}
//                               {item.cat2 && `, ${item.cat2}`}
//                               {item.cat3 && `, ${item.cat3}`}
//                             </h4>
//                           </div>
//                           <div className="w-full">
//                             <div className="bg-gray-50 border border-gray-200 rounded-lg p-4">
//                               <div className="space-y-2">
//                                 <div className="flex justify-between text-sm text-gray-600">
//                                   <span>Unit Price:</span>
//                                   <span>₹{parseFloat(item.final_price).toFixed(2)}</span>
//                                 </div>
//                                 <div className="flex justify-between text-sm text-gray-600">
//                                   <span>Quantity:</span>
//                                   <span>{item.quantity}</span>
//                                 </div>
//                                 <div className="flex justify-between text-sm text-gray-600">
//                                   <span>Margin:</span>
//                                   <span>{getMarginForItem(item.mc_name)}%</span>
//                                 </div>
//                                 <div className="border-t border-gray-300 pt-2 mt-2">
//                                   <div className="flex justify-between font-bold text-orange-600">
//                                     <span>Total:</span>
//                                     <span>₹{(item.final_price * item.quantity).toFixed(2)}</span>
//                                   </div>
//                                 </div>
//                               </div>
//                             </div>
//                           </div>
//                         </div>
//                       </div>
//                     ))
//                   ) : (
//                     <p className="text-gray-500 text-center py-4">No items in this card.</p>
//                   )}
//                 </div>
//               </div>
//             ))
//           ) : (
//             <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
//               <p className="text-gray-500">No quotation data available</p>
//             </div>
//           )}
//         </div>
//       </div>

//       {/* Fixed Grand Total and Action Buttons */}
//       {quotation?.cards?.length > 0 && (
//         <div className="bg-white p-4 sm:p-6 border-t border-gray-200 shadow-sm sticky bottom-0 z-10">
//           <div className="max-w-full mx-auto">
//             <div className="flex justify-between items-center mb-4">
//               <h3 className="text-lg font-semibold text-gray-700">Grand Total</h3>
//               <p className="text-xl font-bold text-orange-600">₹{calculateGrandTotal()}</p>
//             </div>
//             {!isConfirmed && (
//               <div className="flex flex-row sm:gap-4 gap-1 justify-end">
//                 <button
//                   onClick={handleSaveAndExit}
//                   className="px-6 py-3 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors shadow-sm font-medium w-full"
//                   disabled={isLoading}
//                 >
//                   Save and Exit
//                 </button>
//                 <button
//                   onClick={() => setIsModalOpen(true)}
//                   className="px-6 py-3 bg-orange-600 text-white rounded-md hover:bg-orange-700 transition-colors shadow-sm font-medium w-full"
//                   disabled={isLoading}
//                 >
//                   Confirm
//                 </button>
//               </div>
//             )}
//           </div>
//         </div>
//       )}

//       <ConfirmationModal
//         isOpen={isModalOpen}
//         onClose={() => setIsModalOpen(false)}
//         onConfirm={handleConfirmAction}
//       />
//     </div>
//   );
// };

// export default Preview;