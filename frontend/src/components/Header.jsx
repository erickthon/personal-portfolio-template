import { useEffect, useState } from 'react';

export default function Header() {
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    const isDark = localStorage.getItem('theme') === 'dark';
    setDarkMode(isDark);
    document.documentElement.classList.toggle('dark', isDark);
  }, []);

  const toggleTheme = () => {
    const newTheme = !darkMode;
    setDarkMode(newTheme);
    localStorage.setItem('theme', newTheme ? 'dark' : 'light');
    document.documentElement.classList.toggle('dark', newTheme);
  };

  return (
    <header className="flex flex-col md:flex-row items-center justify-between px-6 py-4 bg-white dark:bg-gray-800 shadow-md">
      <h1 className="text-xl font-bold text-gray-800 dark:text-white mb-2 md:mb-0">
        Portfolio
      </h1>

      <div className="flex items-center space-x-3">
        <a
          href="/api/resume"
          target="_blank"
          rel="noopener noreferrer"
          className="text-sm bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded transition"
        >
          📄 Resume
        </a>

        <button
          onClick={toggleTheme}
          className="text-sm bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 px-3 py-1 rounded transition"
        >
          {darkMode ? '☀ Light' : '🌙 Dark'}
        </button>
      </div>
    </header>
  );
}
