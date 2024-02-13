# Parse API + Authentication

This is the API and authentication for the Parse application. It's built with Rails 7.1.3. The frontend is a Next.js application that uses session cookies to authenticate requests. In the future users will also be able to get API keys to access their data and build integrations. Users are authenticated via the Rails app and then redirected to the Next.js app.

I'm currently in the process of rewriting the backend using Rails, the original app used Supabase for the backend logic, database, and auth. The application is currently in a broken state and is not ready for use. An overview of progress is shown below:

- [x] Set up auth with OAuth (Google, GitHub, etc.)
- [x] Wire up basic auth redirect to the Next.js frontend
- [x] Set up ActiveStorage for file uploads
- [x] Set up User and Team model for multi-tenancy
- [x] Post resources and basic CRUD
- [x] Comment resources and basic CRUD
- [x] Group resources and basic CRUD
- [ ] Reaction resources and basic CRUD
- [ ] Notifications resources and basic CRUD
- [ ] Catch up on model and controller tests
- [ ] Group feed controller updates
- [ ] Mailer setup
- [ ] Invite system for teams
- [ ] Triage resources and basic CRUD
- [ ] Goals resources and basic CRUD
- [ ] Pagination for relevant resources (posts, comments, team members, etc.)
- [ ] User settings + preferences endpoints

## Getting Started

Make sure you have the relevant version of Ruby and Rails installed. See Gemfile for details.

Start by forking or cloning the repo and then `cd` into the project directory. Then, install the dependencies:

```bash
bundle install
```

Set up your database config then create the database and run migrations:

```bash
rails db:create
rails db:migrate
```

Copy the `.env.example` file using `cp .env.example .env` and fill in the environment variables with the appropriate values.

Then start the development server:

```bash
bin/dev
```

This will start both the Rails server as well as the Tailwind CSS JIT compiler.
