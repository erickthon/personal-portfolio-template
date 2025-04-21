export default function ProjectCard({ project }) {
    return (
      <div className="bg-white dark:bg-gray-700 shadow-md p-4 rounded-lg">
        <h3 className="text-xl font-semibold text-gray-800 dark:text-white">
          {project.title}
        </h3>
        <p className="text-gray-600 dark:text-gray-300 my-2">
          {project.description}
        </p>
        <div className="flex flex-wrap gap-2 text-sm mb-2">
          {project.tech.map((t) => (
            <span
              key={t}
              className="bg-gray-200 dark:bg-gray-600 px-2 py-1 rounded"
            >
              {t}
            </span>
          ))}
        </div>
        <a
          href={project.github}
          target="_blank"
          rel="noopener noreferrer"
          className="text-blue-500 dark:text-blue-300 hover:underline"
        >
          View on GitHub →
        </a>
      </div>
    );
  }
  