  import { useState, useEffect } from "react";
  import { useNavigate } from "react-router-dom";
  import AddItems from "../components/AddItems";
  import PickMargin from "../components/PickMargin";
  import CustomerDetails from "../components/CustomerDetails";
  import { FaTrash, FaEdit } from "react-icons/fa";
  import { Link } from "react-router-dom";
  import { v4 as uuidv4 } from "uuid";
  

  console.log("Generated UUID:", uuidv4());

  function HomePage() {
    const [selectedItems, setSelectedItems] = useState([]);
    const [step, setStep] = useState(1); // Tracks the current step
    const [selectedType, setSelectedType] = useState(null); // Tracks material type being edited
    const [selectedSize, setSelectedSize] = useState(null); // Tracks material type being edited
    const [quotationId, setQuotationId] = useState(null); // Holds the quotation ID
    const navigate = useNavigate(); // React Router navigation hook
    const [itemToEdit, setItemToEdit] = useState(null); // Define state to store the fetched item
    const [editingData, setEditingData] = useState(null);



    const isValidUUID = (id) => {
      const uuidRegex =
        /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
      return uuidRegex.test(id);
    };




    useEffect(() => {
      // Retrieve the stored ID from sessionStorage
      const storedQuotationId = sessionStorage.getItem("quotation_id");
      console.log("Retrieved Quotation ID:", storedQuotationId);

      // Validate the stored ID
      if (storedQuotationId && isValidUUID(storedQuotationId)) {
        setQuotationId(storedQuotationId); // Use the valid UUID
      } else {
        // Generate a new UUID if the stored one is invalid or missing
        const newQuotationId = uuidv4();
        console.log("Generated New UUID:", newQuotationId);
        sessionStorage.setItem("quotation_id", newQuotationId); // Store the new UUID
        setQuotationId(newQuotationId);
      }
    }, []);



    useEffect(() => {
      console.log("Editing data:", itemToEdit);
      if (itemToEdit) {
        setSelectedType(itemToEdit.type);
        setSelectedSize(itemToEdit.size);
        setSelectedItems(itemToEdit.items); // Prefill the items array
      }
    }, [itemToEdit]);

    useEffect(() => {
      console.log("Before useEffect, itemToEdit:", itemToEdit); // Log state before re-render
    }, [itemToEdit]);  // Effect will run when itemToEdit changes
    
    
    
    const parentFormId = editingData ? editingData.form_id : uuidv4();
    console.log('below paretn form id editing data checl',editingData);
    console.log('below paretn form id form id check',parentFormId);

    const handleItemSelection = (newData) => {
      console.log("Adding item:", newData);
      if (itemToEdit) {
        // Update the specific form group by form_id
        setSelectedItems((prev) =>
          prev.map((group) =>
            group.form_id === itemToEdit.form_id ? { ...group, ...newData } : group
          )
        );
        setItemToEdit(null); // Clear editing state after update
      } else {
        // Add new form group
        const newGroup = {
          form_id: parentFormId,   // Generate a new unique form ID
          ...newData,
        };
        setSelectedItems((prev) => [...prev, newGroup]);
      }
      setStep(2); // Automatically move to the next step (or use conditional logic for better UX)
    };
    
    const handleDelete = (form_id) => {
      try {
        console.log("Deleting item with form_id:", form_id);
        setSelectedItems((prevItems) => prevItems.filter((item) => item.form_id !== form_id));
      } catch (error) {
        console.error("Error during deletion:", error);
      }
    };
    
    useEffect(() => {
      if (editingData) {
        console.log("Editing data outside handleEdit:", editingData);
      }
    }, [editingData]);

    const handleEdit = (formId) => {
      console.log("Selected items:", selectedItems);  // Log this to check if selectedItems has the correct data
      console.log("form id:", formId);  // Log this to check if selectedItems has the correct data
      const itemToEdit = selectedItems.find((group) => group.form_id === formId);
      console.log("Item to edit:", itemToEdit);  // This will show the item you're trying to edit
      if (itemToEdit) {
        setEditingData(itemToEdit);
      }
    };


    console.log("item to edit now", itemToEdit);
    useEffect(() => {
      console.log("Updated selected items:", selectedItems);  // Log the items after they change
    }, [selectedItems]);
    

    const handleNextStep = () => {
      setStep((prevStep) => prevStep + 1);
    };

    const accordionStyle = (isEnabled) => ({
      marginBottom: "20px",
      padding: "15px",
      backgroundColor: isEnabled ? "#FDFBEF" : "#e0e0e0",
      pointerEvents: isEnabled ? "auto" : "none",
      opacity: isEnabled ? 1 : 0.6,

    });

    const handlePreview = async () => {
      // Validate and generate unique IDs for items
      const validatedItems = selectedItems.map((group) => {
        // Ensure each group has valid items, and all items have unique IDs
        const updatedItems = group.items.map((item) => ({
          ...item,
          id: item.id || uuidv4(), // Ensure unique ID if not already present
        }));
    
        return { ...group, items: updatedItems };
      });
    
      setSelectedItems(validatedItems); // Update state with validated items
    
      const marginMap = {};
    
      // Ensure each item has a valid margin
      validatedItems.forEach((group) => {
        group.items.forEach((item) => {
          if (!item.userMargin) {
            console.error(`Missing userMargin for item: ${item.mc_name}`);
          } else if (!marginMap[item.mc_name]) {
            marginMap[item.mc_name] = item.userMargin;
          }
        });
      });
    
      console.log("Margin Map:", marginMap);
    
      const isValidMargin = Object.values(marginMap).every(
        (margin) => typeof margin === "number" && margin > 0
      );
    
      if (!isValidMargin) {
        alert("Please ensure all items have valid margins before proceeding.");
        return;
      }
    
      const payload = {
        quotation_id: quotationId,
        items: validatedItems.map((group) => ({
          type: group.type,
          size: group.size,
          items: group.items.map((item) => ({
            // item_id: item.id, // Ensure valid ID is used
            article: item.name,
            quantity: item.quantity,
            category: item.category,
            margin: marginMap[item.mc_name], // Correctly map margin
            discount_rate: item.discount_rate,
            net_rate : item.net_rate,
            mrp : item.mrp
          })),
        })),
      };
    
      console.log("Payload:", payload);


    
      try {
        // Send the payload to the backend
        const response = await fetch("https://puranmalsons-quotation-webapp-0b4c571a2cc2.herokuapp.com/api/quotations/", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
    
        const responseText = await response.text();
        const data = responseText ? JSON.parse(responseText) : null;
    
        if (response.ok) {
          if (data?.quotation_id) {
            navigate("/preview", { state: { quotationId: data.quotation_id } });
          } else {
            alert("Error: Quotation ID missing");
          }
        } else {
          console.error("Backend Response Error:", data || responseText);
          alert(`Backend Error: ${data?.error || responseText}`);
        }
      } catch (error) {
        console.error("Network Error:", error);
        alert("Error: " + error.message);
      }
    };

    useEffect(() => {
      console.log("itemToEdit has changed:", itemToEdit);
  }, [itemToEdit]);
    

    const handleShare = () => {
      const message = `Check out the quotation for your order! Quotation ID: ${quotationId}`;
      const url = `https://wa.me/?text=${encodeURIComponent(message)}`;
      window.open(url, "_blank");
    };



    return (
      <div
        style={{ fontFamily: "Arial, sans-serif", color: "#333"  }}
      >
        <h1 style={{ textAlign: "start", fontSize: "24px", color: "#f39c12", backgroundColor: '#FDFBEF', padding: '20px'}}>
          Puranmal Sons
        </h1>
        <h2 style={{ textAlign: "start", color: "#555", fontSize: '18px', padding: '0px 20px' }}>
          Request for Proposal
        </h2>

        {/* Display grouped selected items */}
        {selectedItems.map((group, index) => (
          <div
            key={index}
            style={{
              marginBottom: "20px",
              padding: "10px",
              borderRadius: "8px",
              backgroundColor: "#FDFBEF",
              margin: '20px'
            }}
          >
            <h3
              style={{ color: "black", fontSize: "18px", fontWeight: "bold" }}
            >
              {group.type}  : {group.size}
            </h3>
            <p style={{ margin: "5px 0", color: "#555" }}>
              Size: <strong>{group.size}</strong>
            </p>
            <p style={{ margin: "5px 0", color: "#333" }}>
              Items:{" "}
              <strong>
                {group.items
                  .map((item) => `${item.name} (Qty: ${item.quantity})`)
                  .join(", ")}
              </strong>
            </p>
            <div style={{ marginTop: "10px" }}>
              <button
                style={{
                  marginRight: "10px",
                  padding: "5px",
                  color: "#fff",
                  backgroundColor: "#e74c3c",
                  border: "none",
                  borderRadius: "4px",
                  cursor: "pointer",
                }}
                onClick={() => handleDelete(group.form_id)}
              >
                <FaTrash style={{ marginRight: "5px" }} /> Delete
              </button>
              <button
                style={{
                  padding: "5px",
                  color: "#fff",
                  backgroundColor: "#3498db",
                  border: "none",
                  borderRadius: "4px",
                  cursor: "pointer",
                }}
                onClick={() => handleEdit(group.form_id)}
              >
                <FaEdit style={{ marginRight: "5px" }} /> Change
              </button>
            </div>
          </div>
        ))}

        {/* Add Items Accordion */}
        <div style={accordionStyle(step >= 1)}>
        {console.log("Editing data before passing to AddItems:", itemToEdit)}
          
          <AddItems
           parentFormId={parentFormId}
            onItemSelection={handleItemSelection}
            editingData={editingData}
            quotationId={quotationId}
          />
        </div>

        {/* Pick Margin Accordion */}
        <div style={accordionStyle(step >= 2)}>
          {step >= 2 && ( 
            <PickMargin
              handleNextStep={handleNextStep}
              quotationId={quotationId}
              selectedItems={selectedItems}
              setSelectedItems={setSelectedItems}
            />
          )}
          {step < 2 && <p>Complete the previous steps before proceeding.</p>}
        </div>

        {/* Customer Details Accordion */}
        <div style={accordionStyle(step >= 3)}>
          {step >= 3 && <CustomerDetails />}
          {step < 2 && <p>Complete the previous steps before proceeding.</p>}
        </div>

        <div style={{ marginTop: "20px", display: "flex", justifyContent: "space-between" }}>
          <Link to={{
      pathname: "/preview",
      state: { quotationId: quotationId }, // Replace `yourQuotationId` with the actual ID
    }}
    >
          <button
            style={{
              padding: "10px 15px",
              fontSize: "16px",
              backgroundColor: "#27ae60",
              color: "#fff",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
              margin: '20px'
            }}
            onClick={handlePreview}
            
          >
            Preview
          </button>
          </Link>
          <button
            style={{
              padding: "10px 15px",
              fontSize: "16px",
              backgroundColor: "#f39c12",
              color: "#fff",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
              margin: '20px'
            }}
            onClick={handleShare}
          >
            Share on WhatsApp
          </button>
        </div>
      </div>
    );
  }

  export default HomePage;
