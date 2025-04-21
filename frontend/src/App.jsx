import { useEffect, useState } from 'react';
import Header from './components/Header';
import Footer from './components/Footer';
import ProjectCard from './components/ProjectCard';

function App() {
  const [projects, setProjects] = useState([]);

  useEffect(() => {
    fetch('/api/projects')
      .then((res) => res.json())
      .then((data) => setProjects(data))
      .catch(console.error);
  }, []);

  return (
    <div className="min-h-screen flex flex-col">
      <Header />
      <main className="flex-1 container mx-auto px-4 py-8 space-y-16">
        
        {/* HERO SECTION */}
        <section className="text-center space-y-4">
          <img
            src="/avatar.png"
            alt="avatar"
            className="mx-auto w-32 h-32 rounded-full shadow-lg object-cover"
          />
          <h1 className="text-4xl font-bold">Hi, I’m  👋</h1>
          <p className="text-lg text-gray-600 dark:text-gray-300">
                      Awesome | Human | Being
          </p>
        </section>


        {/* ABOUT SECTION */}
        <section className="max-w-3xl mx-auto text-center space-y-4">
          <h2 className="text-2xl font-semibold">About Me</h2>
          <p className="text-gray-700 dark:text-gray-300">
          I'm a [role or title] with experience in [industry/type of work].
          I've worked with [team/org types] and focus on [skills or interests]. Always learning, always building.
          </p>
          <p className="text-sm text-gray-500 dark:text-gray-400">
            💡 Certificates · Kubernetes · Terraform · Ansible · CI/CD · Observability
          </p>
        </section>

        {/* PROJECTS SECTION */}
        <section>
          <h2 className="text-2xl font-semibold mb-6 text-center">Projects</h2>
          <div className="grid gap-6 md:grid-cols-2">
            {projects.map((proj, index) => (
              <ProjectCard key={index} project={proj} />
            ))}
          </div>
        </section>

        {/* CONTACT SECTION */}
        <section className="text-center space-y-4">
          <h2 className="text-2xl font-semibold">Contact Me</h2>
          <p className="text-gray-700 dark:text-gray-300">
            Feel free to reach out for opportunities or just say hi!
          </p>
          <a
            href="mailto:you@example.com"
            className="inline-block bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700 transition"
          >
            📬 Send Email
          </a>
        </section>
      </main>
      <Footer />
    </div>
  );
}

export default App;
