import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import AddItem from "./components/AddItems";
import Home from "./pages/Home";
import FormPage from "./pages/FormPage";
import Preview from "./pages/Preview";
import "./App.css";


function App() {

  return (
    <Router>
      <div className="flex min-h-screen">
        {/* {% extends 'layout.html'%} */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/home" element={<FormPage />} />
          <Route path="/additems" element={<AddItem />} />
          <Route path="/preview" element={<Preview />} />
          <Route path="/preview/:id" element={<Preview />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
