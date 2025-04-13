// const TableContent = () => {
//     let userTable = [
//       {
//         title: "SNo.",
//         render: (rowData) => <span>{rowData.id}</span>,
//       },
//       {
//         title: "Make",
//         render: (rowData) => <span>{rowData.make ?? "N/A"}</span>,
//       },
//       {
//         title: "Item Image",
//         render: (rowData) => (
//           <img src={rowData.items?.[0]?.image_url ?? "placeholder.jpg"} alt="Item" width={50} />
//         ),
//       },
//       {
//         title: "Type",
//         render: (rowData) => <span>{rowData.type ?? "N/A"}</span>,
//       },
//       {
//         title: "Size",
//         render: (rowData) => <span>{rowData.size ?? "N/A"}</span>,
//       },
//       {
//         title: "Article",
//         render: (rowData) => <span>{rowData.items?.[0]?.article ?? "N/A"}</span>,
//       },
//       {
//         title: "Unit",
//         render: () => <span>Nos</span>,
//       },
//       {
//         title: "Quantity",
//         render: (rowData) => <span>{rowData.items?.[0]?.quantity ?? "N/A"}</span>,
//       },
//       {
//         title: "Rate",
//         render: (rowData) => <span>{rowData.items?.[0]?.final_price ?? "N/A"}</span>,
//       },
//       {
//         title: "GST",
//         render: (rowData) => <span>{rowData.gst ?? "N/A"}</span>,
//       },
//       {
//         title: "Net Rate",
//         render: (rowData) => <span>{rowData.items?.[0]?.final_price ?? "N/A"}</span>,
//       },
//       {
//         title: "Amount",
//         render: (rowData) => <span>{rowData.items?.[0]?.total_price ?? "N/A"}</span>,
//       },
//     ];
  
//     return userTable;
//   };
  
//   export default TableContent;
  