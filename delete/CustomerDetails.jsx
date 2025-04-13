// import { useState, useEffect } from "react";
// import { FaCheckCircle, FaPlus, FaMinus } from "react-icons/fa";
// import axios from "axios"; // Import axios to make HTTP requests
// import './CustomerDetails.css'; // Import the CSS file

// const CustomerDetailsAccordion = () => {
//   const [isExpanded, setIsExpanded] = useState(true);
//   const [isSaved, setIsSaved] = useState(false);
//   const [title, setTitle] = useState("");
//   const [name, setName] = useState("");
//   const [address, setAddress] = useState("");
//   const [phoneNumber, setPhoneNumber] = useState("");
//   const [whatsappNumber, setWhatsappNumber] = useState("");
//   const [sameAsPhone, setSameAsPhone] = useState(false);

//   useEffect(() => {
//     const savedData = JSON.parse(localStorage.getItem("customerDetails")) || {};
//     setTitle(savedData.title || "");
//     setName(savedData.name || "");
//     setAddress(savedData.address || "");
//     setPhoneNumber(savedData.phoneNumber || "");
//     setWhatsappNumber(savedData.whatsappNumber || "");
//     setSameAsPhone(savedData.sameAsPhone || false);
//   }, []);

//   useEffect(() => {
//     const debounceSave = setTimeout(() => {
//       const customerDetails = {
//         title,
//         name,
//         address,
//         phoneNumber,
//         whatsappNumber,
//         sameAsPhone,
//       };
//       localStorage.setItem("customerDetails", JSON.stringify(customerDetails));
//     }, 1000);

//     return () => clearTimeout(debounceSave);
//   }, [title, name, address, phoneNumber, whatsappNumber, sameAsPhone]);

//   const handlePhoneChange = (e) => {
//     setPhoneNumber(e.target.value);
//     if (sameAsPhone) {
//       setWhatsappNumber(e.target.value);
//     }
//   };

//   const handleWhatsappChange = (e) => {
//     setWhatsappNumber(e.target.value);
//   };

//   const handleSameAsPhone = () => {
//     setSameAsPhone(!sameAsPhone);
//     if (!sameAsPhone) {
//       setWhatsappNumber(phoneNumber);
//     } else {
//       setWhatsappNumber("");
//     }
//   };

//   const handleSubmit = async () => {
//     try {
//       // Prepare customer data
//       const customerData = {
//         title,
//         name,
//         address,
//         phone_number: phoneNumber,
//         whatsapp_number: whatsappNumber,
//       };

//       // Make a POST request to save customer data in the database
//       const response = await axios.post('http://127.0.0.1:5000/customers/', customerData);

//       if (response.status === 201) {
//         setIsExpanded(false);
//         setIsSaved(true);
//       } else {
//         console.error("Failed to save customer data:", response.data.error);
//       }
//     } catch (error) {
//       console.error("Error saving customer data:", error);
//     }
//   };

//   const handleChangeClick = () => {
//     if (isSaved) {
//       setIsExpanded(true);
//       setIsSaved(false);
//     } else {
//       setIsExpanded(!isExpanded);
//     }
//   };

//   return (
//     <div className="customer-details-container">
//       <div className="header-section">
//         <span className="customer-details-heading">Customer Details</span>

//         {!isSaved ? (
//           <div className="toggle-section">
//             <button
//               onClick={handleChangeClick}
//               className="change-button"
//             >
//               {isExpanded ? <FaMinus className="minus-icon" /> : <FaPlus className="plus-icon" />}
//             </button>
//           </div>
//         ) : (
//           <div className="toggle-section">
//             <FaCheckCircle className="check-icon" />
//             <button
//               onClick={handleChangeClick}
//               className="change-button"
//             >
//               Change
//             </button>
//           </div>
//         )}
//       </div>

//       {isExpanded && !isSaved && (
//         <div className="form-section">
//           <form>
//             <div style={{ marginBottom: "15px" }}>
//               <label style={{ display: "block", marginBottom: "5px", fontWeight: "bold" }}>Title</label>
//               <div className="title-radio-group">
//                 <label className="title-radio">
//                   <input
//                     type="radio"
//                     name="title"
//                     value="Mrs."
//                     checked={title === "Mrs."}
//                     onChange={(e) => setTitle(e.target.value)}
//                   />
//                   <span>Mrs.</span>
//                 </label>
//                 <label className="title-radio">
//                   <input
//                     type="radio"
//                     name="title"
//                     value="Mr."
//                     checked={title === "Mr."}
//                     onChange={(e) => setTitle(e.target.value)}
//                   />
//                   <span>Mr.</span>
//                 </label>
//                 <label className="title-radio">
//                   <input
//                     type="radio"
//                     name="title"
//                     value="M/S"
//                     checked={title === "M/S"}
//                     onChange={(e) => setTitle(e.target.value)}
//                   />
//                   <span>M/S</span>
//                 </label>
//               </div>
//             </div>

//             <div className="input-field">
//               <label style={{ display: "block", marginBottom: "5px", fontWeight: "bold" }}>Name</label>
//               <input
//                 type="text"
//                 placeholder="Name"
//                 value={name}
//                 onChange={(e) => setName(e.target.value)}
//                 className="input-field"
//               />
//             </div>

//             <div className="textarea-field">
//               <label style={{ display: "block", marginBottom: "5px", fontWeight: "bold" }}>Address</label>
//               <textarea
//                 placeholder="Address"
//                 value={address}
//                 onChange={(e) => setAddress(e.target.value)}
//                 className="textarea-field"
//               ></textarea>
//             </div>

//             <div className="input-field">
//               <label style={{ display: "block", marginBottom: "5px", fontWeight: "bold" }}>Phone Number</label>
//               <input
//                 type="tel"
//                 placeholder="+91 Phone Number"
//                 value={phoneNumber}
//                 onChange={handlePhoneChange}
//                 className="input-field"
//               />
//             </div>

//             <div className="input-field">
//               <label style={{ display: "block", marginBottom: "5px", fontWeight: "bold" }}>WhatsApp Number</label>
//               <input
//                 type="tel"
//                 placeholder="+91 WhatsApp Number"
//                 value={whatsappNumber}
//                 onChange={handleWhatsappChange}
//                 className="input-field"
//               />
//             </div>

//             <div className="checkbox-section">
//               <label>
//                 <input
//                   type="checkbox"
//                   checked={sameAsPhone}
//                   onChange={handleSameAsPhone}
//                 />
//                 Same as Phone Number
//               </label>
//             </div>

//             <button
//               type="button"
//               onClick={handleSubmit}
//               className="save-button"
//             >
//               Save and Next
//             </button>
//           </form>
//         </div>
//       )}
//     </div>
//   );
// };

// export default CustomerDetailsAccordion;
