import { useState, useEffect } from "react";
import Logo from "../assets/logo2.png";
import PuranmalSons from "../assets/name3.png";

const Layout = ({ homeUrl = "/" }) => {
  const [isLoading, setIsLoading] = useState(false);

  const handleNavClick = (href, external = false) => {
    if (external) {
      window.open(href, "_blank");
      return;
    }

    setIsLoading(true);
    // Add small delay to show loader
    setTimeout(() => {
      window.location.href = href;
    }, 100);
  };

  return (
    <>
      <div>
        {/* Header */}
        <header
          className="w-full shadow-sm"
        >
          <nav className="flex items-center justify-between px-6 py-4">
            {/* Logo and Title Section */}
            <div className="flex items-center space-x-4">
              <button
                onClick={() => handleNavClick(homeUrl)}
                className="flex items-center space-x-3 hover:opacity-80 transition-opacity"
              >
                <img
                  src={Logo}
                  alt="Puranmal Sons Logo"
                  className="h-10 w-10"
                />
                <div className="flex flex-col">
                  <img src={PuranmalSons} alt="Puranmal Sons" className="h-6" />
                </div>
              </button>
            </div>

            {/* Right Side - Home Button */}
            <div className="flex items-center">
              <button
                onClick={() => handleNavClick(homeUrl)}
                className="flex items-center  bg-gray-100 text-gray-400 p-2 rounded-lg"
              >
                <svg
                  width={18}
                  height={18}
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                  <polyline points="9,22 9,12 15,12 15,22" />
                </svg>
                <span className="hidden sm:inline">Home</span>
              </button>
            </div>
          </nav>
        </header>

        {/* Footer
        <footer
          className="mt-auto text-center py-4 text-sm text-gray-600 border-t"
          style={{ backgroundColor: "whitesmoke" }}
        >
          © Created with brains at{" "}
          <a
            href="https://palrigraphy.com"
            className="text-blue-600 hover:underline"
            target="_blank"
            rel="noopener noreferrer"
          >
            palrigraphy
          </a>{" "}
          ™
        </footer> */}
      </div>
    </>
  );
};

export default Layout;
