# Database Assignments Repository

Read the [syllabus](./syllabus.md) for detailed information about the course structure, grading policies, and other important details.

## Accessing the Repository

1. Ask your instructor to add you to the repository if you haven't been added yet.
2. Fork the repository to your own GitHub account by clicking the "Fork" button at the top right of the repository page.

## Git Setup Instructions

- I highly recommend using a nice GUI client.
    - `TortoiseGit` is not a good choice at all. Do not use it.
    - [git-fork](https://git-fork.com/) is a great free GUI client for Git on Windows and MacOS. It is paid but its evaluation version is fully functional and does not expires.
    - [SmartGit](https://www.smartgit.dev/download/) works on all platforms (Windows, MacOS and Linux) and is also a good choice.
    - [GitKraken](https://www.gitkraken.com/) I will be using this one, but it is paid software. It is free for students and open source projects for 6 months.
    - Any JetBrains IDE has built-in Git support that works really well for us.
    - Git bash/command line is also an option, but not recommended for beginners, especially solving on conflicted merges.
- Clone the repository to your local machine. Select short folder path without spaces and special characters:
    - Windows: near your `C` Drive. Ex.: `C:\src\databases`;
    - Linux: near `home` folder. Ex.: `/home/username/src/databases`;
    - MacOS: near `Users` folder. Ex.: `/Users/username/src/databases`;

## IDE Setup Instructions

You may want to use any IDE of your choice, but I will be using JetBrains IDEs for this course, so it will be easier to follow along if you do the same. VS Code is also a good choice, but I will not be providing specific instructions for it,besides that, the autocomplete and other features in JetBrains IDEs are generally better.

1. (Optional) [Apply for Jetbrains Student License](https://www.jetbrains.com/academy/student-pack/). A student license gives you free access to all JetBrains IDEs;
2. Install [Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/);
3. Login to Jetbrains Toolbox using your student account;
    - Once you log in, you will have access to all JetBrains IDEs for free as long as you are a student.
4. Install the following tools via Jetbrains Toolbox, they are free for students and non-commercial use
    - (Optional) [DataGrip](https://www.jetbrains.com/datagrip/). This is mostly used for writing and testing SQL queries.
    - [WebStorm](https://www.jetbrains.com/webstorm/).  This will be extensively used for assignments involving JavaScript/TypeScript and Node.js.

::: warning "Disable AI Assistance"

Please disable AI assistance features (like GitHub Copilot, ChatGPT plugins, etc.) in any IDE you use for this course. Relying on AI tools can hinder your learning process and may lead to academic integrity issues.

On JetBrains IDEs, you can disable:

- AI assistance by going to `Settings/Preferences` > `Plugins` and disabling any AI-related plugins, such as 
    - `GitHub Copilot`,
    - `Trae AI`,
    - or any other similar plugins you may have installed.
- In WebStorm, you can also disable AI code completion by going to `Settings/Preferences` > `Editor` > `General` > `Inline Completion` and unchecking the option for AI-based suggestions: such as
    - `Enable local Full Line completion Sugestions`, 
    - `Enable automatic completion on typing`
    - `Enable multi-line suggestions`.

:::

## Node.js Setup Instructions

- Install [`node.js`](https://nodejs.org/en/download/) LTS version on your machine. 
- Make sure it is properly installed by running the following commands in your terminal/command prompt:

``` bash
node -v
npm -v
```

::: tip "docker as node environment"

You may also use Docker as your Node.js environment if you prefer not to install Node.js directly on your machine. Each assignment includes a `docker-compose.yml` file that sets up the required Node.js environment for you.

:::

## Repository structure

- Each assignment is in its own folder named `assignment-<number>`, e.g., `assignment-1`, `assignment-2`, etc.
- Each assignment folder contains:
    - `README.md`: Instructions for the assignment;
    - `docker-compose.yml`: Docker Compose file to set up the required environment;
    - Other files and folders as needed for the assignment, refer to the `README.md` in each assignment folder for details.
- `.github/workflows/`: Contains GitHub Actions workflows for automated testing of assignments. **Do not modify these files**.
- `.gitignore`: Specifies files and folders to be ignored by Git. You may modify this file if needed.
- `scripts/`: Contains helper scripts for running tests and other tasks. Do not modify these files.
- `reports/`: Will contain any generated files or outputs from assignments. Do not modify these files.

## Testing Assignments

- Each assignment includes automated tests that you can run locally using Docker.
- You may want to check the tab "Actions" on GitHub to see the results of automated tests run on your submissions.
- You may want to use `act` to run GitHub Actions workflows locally. Refer to [act documentation](https://github.com/nektos/act).