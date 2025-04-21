export default function Footer() {
    return (
      <footer className="text-center text-gray-600 dark:text-gray-400 py-6">
        <p>© {new Date().getFullYear()}. All rights reserved.</p>
        <div className="mt-2">
          <a
            href="https://github.com/yourusername/yourproject"
            className="hover:underline text-blue-500 dark:text-blue-300"
          >
            GitHub
          </a>{' '}
          ·{' '}
          <a
            href="mailto:you@example.com"
            className="hover:underline text-blue-500 dark:text-blue-300"
          >
            Email
          </a>
        </div>
      </footer>
    );
  }
  