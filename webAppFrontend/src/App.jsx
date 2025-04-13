import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import AddItem from "./components/AddItems";
import Home from "./pages/Home";
import FormPage from "./pages/FormPage";
import Preview from "./pages/Preview";
import "./App.css";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/home" element={<FormPage />} />

        <Route path="/additems" element={<AddItem />} />
        <Route path="/preview" element={<Preview />} />
      </Routes>
    </Router>
  );
}

export default App;
