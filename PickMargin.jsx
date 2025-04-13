// import { useState } from "react";
// import { FiPlus, FiMinus } from "react-icons/fi"; // Accordion icons
// import { FaCheckCircle } from "react-icons/fa"; // Checkmark icon
// import './PickMargin.css'

// const PickMargin = ({ selectedItems, setSelectedItems, handleNextStep, quotationId }) => {
//   const [expanded, setExpanded] = useState(false);
//   const [isCompleted, setIsCompleted] = useState(false);
//   const [editingItemIndex, setEditingItemIndex] = useState(null);
//   const [editingGroupIndex, setEditingGroupIndex] = useState(null);

//   const handleMarginChange = (groupIndex, itemIndex, margin) => {
//     setEditingGroupIndex(groupIndex);
//     setEditingItemIndex(itemIndex);

//     const updatedItems = selectedItems.map((group, gIdx) => ({
//       ...group,
//       items: group.items.map((item, iIdx) =>
//         gIdx === groupIndex && iIdx === itemIndex
//           ? { ...item, userMargin: parseFloat(margin) || 0 }
//           : item
//       ),
//     }));
//     setSelectedItems(updatedItems);
//   };

//   const allFieldsFilled = selectedItems.every((group) =>
//     group.items.every((item) => item.userMargin !== undefined && item.userMargin !== 0)
//   );
  
//   const handleSaveAndNext = () => {
//     if (!allFieldsFilled) {
//       alert("Please fill in margins for all items before proceeding.");
//       return;
//     }

//     if (editingGroupIndex !== null && editingItemIndex !== null) {
//       const marginData = {
//         mc_name:
//           selectedItems[editingGroupIndex].items[editingItemIndex].mc_name,
//         margin:
//           selectedItems[editingGroupIndex].items[editingItemIndex].userMargin,
//         quotation_id: quotationId
//       };

//       fetch("http://localhost:5000/pickmargins/", {
//         method: "POST",
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: JSON.stringify(marginData),
//       })
//         .then((response) => {
//           if (!response.ok) {
//             throw new Error(`Error adding margin: ${response.statusText}`);
//           }
//           return response.json();
//         })
//         .then((data) => {
//           console.log("Margin added successfully:", data);
//           // Optionally: Update UI to reflect successful addition 
//           // (e.g., clear the input field, show a success message)
//         })
//         .catch((error) => {
//           console.error("Error adding margin:", error);
//           // Handle errors appropriately, like showing an error message to the user
//           alert("Error adding margin. Please try again."); 
//         });
//     } else {
//       console.error("No item selected for margin update.");
//       alert("No item selected for margin update."); 
//       return;
//     }

//     setIsCompleted(true);
//     setExpanded(false);
//     handleNextStep();
//   };

//   const toggleAccordion = () => {
//     setExpanded((prev) => !prev);
//   };

//   const handleChangeClick = () => {
//     setExpanded(true);
//     setIsCompleted(false);
//   };

//   return (
//     <div>
//       {/* Accordion Header */}
//       <div
//         className="accordion-header"
//         style={{
//           display: "flex",
//           justifyContent: "space-between",
//           alignItems: "center",
//           cursor: "pointer",
//           backgroundColor: "#fdfbef",
//           // padding: "10px 15px",
//           borderRadius: "5px",
//           color: '#FF913C'
//         }}
//         onClick={isCompleted ? undefined : toggleAccordion}
//       >
//         <div style={{ display: "flex", alignItems: "center" }}>
//           <h2 style={{ fontWeight: "bold" }}>
//             Pick Your Margin
//           </h2>
//           {isCompleted && (
//             <FaCheckCircle style={{ color: "green", fontSize: "16px" }} />
//           )}
//         </div>
//         {isCompleted ? (
//           <button
//             style={{
//               color: "orange",
//               background: "none",
//               border: "none",
//               fontWeight: "bold",
//               cursor: "pointer",
//               textDecoration: "underline",
//             }}
//             onClick={handleChangeClick}
//           >
//             Change
//           </button>
//         ) : expanded ? (
//           <FiMinus className="accordion-icon" />
//         ) : (
//           <FiPlus className="accordion-icon" />
//         )}
//       </div>

//       {/* Accordion Content */}
//       {expanded && (
//         <div
//           className="accordion-content"
//           style={{
//             // padding: "10px 15px",
//           }}
//         >
//           {selectedItems.map((group, groupIndex) => (
//             <div key={groupIndex}>
//               <h4 style={{ marginBottom: "10px" }}>{group.material}</h4>
//               {group.items.map((item, itemIndex) => (
//                 <div
//                   key={itemIndex}
//                   style={{
//                     display: "flex",
//                     alignItems: "center",
//                     marginBottom: "20px",
//                     justifyContent: "space-between"
//                   }}
//                 >
//                   <span style={{ marginRight: "10px", fontWeight: "bold" }}>
//                     {item.mc_name}
//                   </span>
//                   <input
//                     type="number"
//                     value={item.userMargin || ""}
//                     onChange={(e) =>
//                       handleMarginChange(groupIndex, itemIndex, e.target.value)
//                     }
//                     placeholder="Enter margin"
//                     style={{
//                       padding: "10px",
//                       border: "1px solid #ccc",
//                       borderRadius: "6px",
//                       width: "100px",
//                       marginRight: "10px",
//                       fontSize: '14px'
//                     }}
//                   />
//                 </div>
//               ))}
//             </div>
//           ))}
//           <button
//             type="button"
//             onClick={handleSaveAndNext}
//             disabled={!allFieldsFilled}
//             style={{
//               // padding: "10px 20px",
//               backgroundColor: allFieldsFilled ? "green" : "#ccc",
//               color: "#fff",
//               border: "none",
//               borderRadius: "5px",
//               cursor: allFieldsFilled ? "pointer" : "not-allowed",
//             }}
//           >
//             Save and Next
//           </button>
//         </div>
//       )}
//     </div>
//   );
// };

// export default PickMargin;