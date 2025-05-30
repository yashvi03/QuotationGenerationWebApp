import { useState, useEffect } from 'react';
import { Home } from 'lucide-react';
import Logo from '../assets/logo2'
import PuranmalSons from '../assets/name3'

const Layout = ({ title = "Quotation", homeUrl = "/" }) => {
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    // Set page title
    document.title = `Puranmal Sons : ${title}`;
  }, [title]);

  const handleNavClick = (href, external = false) => {
    if (external) {
      window.open(href, '_blank');
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
      {/* Google Fonts */}
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="true" />
      <link
        href="https://fonts.googleapis.com/css2?family=Glegoo:wght@700&family=Kalam:wght@300&family=Khula:wght@600&family=Laila:wght@400;700&family=Martel:wght@400;900&family=Raleway&display=swap"
        rel="stylesheet"
      />

      <div className="min-h-screen" style={{ backgroundColor: 'whitesmoke', fontFamily: "'Raleway', sans-serif" }}>
        {/* Loader */}
        {isLoading && (
          <div className="fixed inset-0 flex items-center justify-center z-50" style={{ backgroundColor: '#242f3f' }}>
            <div 
              className="relative border-4 border-white animate-spin"
              style={{
                width: '30px',
                height: '30px',
                borderRadius: '50%'
              }}
            />
          </div>
        )}

        {/* Header */}
        <header className="w-full shadow-sm" style={{ backgroundColor: '#343a40' }}>
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
                  <img
                    src={PuranmalSons}
                    alt="Puranmal Sons"
                    className="h-6"
                  />
                  <span className="text-gray-300 text-sm mt-1">{title}</span>
                </div>
              </button>
            </div>

            {/* Right Side - Home Button */}
            <div className="flex items-center">
              <button
                onClick={() => handleNavClick(homeUrl)}
                className="flex items-center space-x-2 bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg transition-colors"
              >
                <Home size={18} />
                <span className="hidden sm:inline">Home</span>
              </button>
            </div>
          </nav>
        </header>

        {/* Main Content Area */}
        <main className="p-6">
          <div className="max-w-7xl mx-auto">
            <h1 className="text-2xl font-bold text-gray-800 mb-6">{title}</h1>
            {/* Your page content would go here */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <p className="text-gray-600">Main content area - replace this with your actual content</p>
            </div>
          </div>
        </main>

        {/* Footer */}
        <footer 
          className="mt-auto text-center py-4 text-sm text-gray-600 border-t"
          style={{ backgroundColor: 'whitesmoke' }}
        >
          © Created with brains at{' '}
          <a 
            href="https://palrigraphy.com" 
            className="text-blue-600 hover:underline"
            target="_blank"
            rel="noopener noreferrer"
          >
            palrigraphy
          </a>{' '}
          ™
        </footer>
      </div>
    </>
  );
};

export default Layout;