# Config README

This is a base app install of Rails with the following configurations:

- Ruby 3.3.5
- Rubocop opinions (and Github workflow actions)
- Config for fonts in the Asset Pipeline
- PostCSS
- Tailwind compiled with PostCSS
- Flowbite
- Base `HomeController` with `index` view
- Config for deploy on [Render](https://render.com)
- RSpec (and Github workflow actions)
- Constants module for shared values
- `db:seed:file_name` custom task helper

## Configuration items

### Database config

1. Update environment variable names in `.env`, `.env.sample`, and `config/database.yml` to new app name instead of `BASEAPP`

### Render config

1. Rename `baseapp` in `render.yml` to new app name

### Branding config

1. Add color vars to `app/assets/stylesheets/colors.tailwind.css` using only RGB channel values
2. Update Tailwind theme to use these colors in `tailwind.config.js`

### README config

1. Replace `baseapp` with new app name in README.md (see below)

# Baseapp README

## Environment Setup

> [!IMPORTANT]
> Make sure to install these pre-requisistes first:
>
> - Ruby 3.3.2 ([chruby](https://github.com/postmodern/chruby) is recommended for managing Ruby versions)
> - Rails 7.1 (follow [this guide](https://guides.rubyonrails.org/development_dependencies_install.html) to install)
> - Postgres (either via brew or [Postgres.app](https://postgresapp.com/))

Once you're ready to go, you'll need to make sure to install via both Bundler and NPM:

```bash
bundle install
npm install
```

Local development uses Foreman to run two paralell processes: one for the Rails server (`rails s`) and one for compiling Tailwind (`npm build:css --watch`). To start these, simply run:

```bash
bin/dev
```

> [!TIP]
> It's also recommended that you pull the latest changes from the `main` branch and rebase them into your working branch every day to avoid merge conflicts.
>
> ```bash
> git checkout main
> git pull
> git checkout your-branch
> git rebase main
> ```

This repo makes use of the `pry-byebug` and `pry-rails` gems for debugging. You can insert a `binding.pry` statement in your code to pause execution and open a REPL in the terminal (similar to `debugger` in JavaScript). You can do this anywhere Ruby is parsed in the codebase, including in tests. For testing email, `letter_opener` catches emails in the development environment and opens them in a browser window.

If you need to run `bundle install` or `rails db:migrate`, Rails will tell you in the command line if you need to do so.

### First time setup

1. Run `bundle install` to install Ruby dependencies
2. Make a copy of `.env` from `.env.example`, and update these values:
    - `BASEAPP_DATABASE_USER` (your local Postgres username)
    - `BASEAPP_DATABASE_PASSWORD` (your local Postgres password)

3. Create, init, and seed your local database:
    ```bash
    rails db:create && rails db:migrate && rails db:seed
    ```

### Optional local environment setup

- You may want to integrate Rubocop into your editor of choice. This project has a `.rubocop.yml` file that Rubocop will use to enforce code style. You can install the Rubocop extension for your editor to see these style violations inline. Some will even automatically re-format for you.

### Making a pull request

When you make a pull request (PR), you'll want to be sure that the following things are true:

- Your code is up-to-date with the `main` branch
- Your code passes all tests
- Your code is styled according to Rubocop

To check these things, run the following commands:

```bash
# update with latest from main:
git checkout main
git pull
git checkout your-branch
git rebase main

# run tests
bundle exec rspec

# check style
bundle exec rubocop
```

## Code base quirks

### Constants

This project uses constants to store values that are used in multiple places. These are defined using YAML files in `config/constants/`. You can access these constants in your code by using the `Constants` module. For example:

```ruby

# get a single value
Constants.example.value

# get all values
Constants.example.values
```

> [!IMPORTANT]
> This means that `values` is a special keyword and should not be used in the constants file.

### Helper files

We use helper files for shared functionality that doesn't belong in a model or controller. These are stored in `app/helpers/`. Display logic for data typically would rest with the model, but if you need repeated configration that doesn't make sense to be in a model, you can put it in a helper file.

Common examples of things that might go in a helper file are:

- navigation config
- mapping data to display values
- configuration for a third-party service

### `# frozen_string_literal: true`

This project uses `# frozen_string_literal: true` at the top of each Ruby file. This is a magic comment that tells Ruby to freeze all string literals in the file. This means that you cannot modify the string in place. This is a good practice because it helps prevent bugs where you accidentally modify a string that you didn't mean to.

> [!NOTE]
> Rubocop will enforce this rule, so you don't need to worry about adding it yourself. If you have installed Rubocop in your editor, it will even automatically add this comment to new files.

## Working with the front end

We don't use React or any other frontend framework, but we do make use of Rails' partials to create reusable components. These are stored either in `app/views/components/` or in a controller-specific directory (such as `app/views/home/components`) if it's scoped to a base controller, such as when there's a marketing-side vs logged in portal side.

### Tailwind best practices

#### `@apply`

In this repo, we rely heavily on Tailwind's `@apply` directive to keep display logic in CSS files and out of the HTML. This can make our Tailwind file pretty long, so there is a custom compile step that looks for specific CSS files to compile into the `public/` directory. In general, we'll want to create a new `*.tailwind.css` file for each controller but may also make separate files for larger components/partials.

These new files should be imported to the base `application.tailwind.css` file or the matching domain-specific `example.tailwind.css` file (such as `marketing.tailwind.css`) above the Tailwind imports.

#### Extending Tailwind classes

Tailwind only includes classes that are used so that the CSS file is as small as possible for the client, but it's a little dumb/simplistic about it. What this means is that if we're using Ruby to programmatically set a class Tailwind won't know and it won't be included in the generated/built CSS. To get around this, we use a set of regexes configured in the `safelist` object in the `module.exports` of `tailwind.config.js`.

#### Pre-defined components/blocks

We have a subscription/membership to [TailwindUI](https://tailwindui.com) and [Flowbite](https://flowbite.com) that we can use to build out components. If you're looking for a component, check there first. The password is in the team 1Password vault.

Most things are based off of a pre-made component, and then the classes are labeled something appropriate and extracted to a CSS file using `@apply`.

### Colors

Colors are defined as CSS variables in `app/assets/stylesheets/colors.tailwind.css` in the `@layer base { :root {}}` block. We intentionally pass in only the channels so that way Tailwind's alpha functions will work with them. (See [Tailwind - Customizing Colors - Using CSS Variables](https://tailwindcss.com/docs/customizing-colors#using-css-variables) for more on that.)

Colors are then referenced by CSS variable name (`var(--color-name)`) in `tailwind.config.js`, which defines the reference names that are used in Tailwind's CSS class building (ie: `text-brand-orange-500` or `bg-brand-orange-700`, etc...).

We define the brand colors and several shade values for them, with the `500` shade and the `DEFAULT` value being the same.

If you need to add a new set of colors with shades, [Noel Delgado's Shadowlord tool](https://noeldelgado.github.io/shadowlord/#716f35) is a great resource for generating shades of a color. You kind of need to eyeball it to get the right shade, but it's a good autogenerator of values to select from.

### Adding a new Tailwind file

To add a new file that needs to be compiled for Tailwind (ie, it's not being `@included`'d in a file that is already being compiled), you'll need to update the `package.json` file. We rely on an NPM package called `npm-run-all` to look for build scripts, so so long as you follow naming conventions it's pretty straightforward.

1. Follow convention and name the file `your-file-name.tailwind.css`
2. Add a new `build:css:your-file-name` _and_ a `watch:css:your-file-name` script to the `package.json` `scripts` object (in alphabetical order):
    ```json
    "scripts": {
      "build:css:your-file-name": "tailwindcss -i ./app/assets/stylesheets/your-file-name.tailwind.css -o ./app/assets/builds/your-file-name.css --minify",

      "watch:css:your-file-name": "tailwindcss -i ./app/assets/stylesheets/your-file-name.tailwind.css -o ./app/assets/builds/your-file-name.css --minify --watch"
    }
    ```
3. Restart `bin/dev`

Your new file will be automatically watched and rebuilt during development now. :)

### A quick note on SASS

This project intentionally does _not_ use SASS, as the benefits that we used to get from SASS are now in common CSS. Additionally, the SASS processor kept breaking the deploy randomly so it was removed. The Rails admin panel techincally does use SASS, so if it is added you'll need to grab a compiled version of its CSS and manually include it in the build.

## Working with specs

This project uses [RSpec](https://github.com/rspec/rspec-rails?tab=readme-ov-file#usage) for testing, in combinatin with [FactoryBot](https://github.com/thoughtbot/factory_bot_rails) to create test fixtures and [Faker](https://github.com/faker-ruby/faker) to generate random data as needed.

It's also supported by a few other gems to help with testing:
- [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner) to clean the database between tests to ensure a clean slate
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) to simplify writing tests for Rails models
- [Email Spec](https://github.com/email-spec/email-spec) to test email deliveries
- [Devise controller tests](https://github.com/heartcombo/devise?tab=readme-ov-file#controller-tests) to test controllers that use Devise

### Running the test suite

You can run the entire test suite with:

```bash
bundle exec rspec
```

You can also run a single test file by specifying the path to the file:

```bash
bundle exec rspec spec/models/user_spec.rb
```

If you want to focus a single test or set of tests, you can use the `focus` tag or the `f` prefix:

```ruby

# using the focus tag
RSpec.describe User do
  it 'does something', focus: true do
    # ...
  end
end

# using the f prefix for a single test
RSpec.describe User do
  fit 'does something' do
    # ...
  end
end

# using the f prefix for a block of tests
RSpec.describe User do
  fcontext 'when something' do # this would also work with `fdescribe`
    it "flimflams" do
      # ...
    end

    it "jimmity jams" do
      # ...
    end
  end
end
```

and only those focused tests will run when you run `bundle exec rspec`.

### Writing tests

When writing tests, you'll want to follow the Arrange-Act-Assert pattern. This means you'll set up the test environment, perform the action you're testing, and then assert that the result is what you expect.

If you are creating a new model, you will want to create a new factory for it in `spec/factories`. You can then use this factory in your tests to create instances of the model that you then act upon. Be sure to use Faker to generate random data for your factories. This will help ensure that your tests are robust and that they don't rely on specific data.

Here's an example of a test for a User model:

```ruby
RSpec.describe User do
  describe "validations" do
    # note: `bulid` comes from FactoryBot, and relies on `spec/factories/user.rb`
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end
  end
end
```

## Working with the database

This project uses Postgres as the database. You can interact with the database using the Rails console. To open the console, run:

```bash
rails c
```

From here, you can interact with the database using ActiveRecord. For example, to find all users, you could run:

```ruby
# list all users
User.all

# find a user by email
User.find_by(email: "foo@example.com")

# find users where name is "Cerberus"
User.where(name: "Cerberus")
```

### Creating seed data

If you need to create seed data for the database, you can do so by creating a new seed file in `db/seeds/`. Make sure to include and run it in `db/seeds.rb`. You can then run the seed file with:

```bash
rails db:seed
```

We want to be careful to not overuse Faker in our seeds, as our seeds should be highly repeatable and easily identifiable. It's okay to use it for filler data (such as paragraphs of text), but we should avoid using it for things like names, titles, or emails.

## Troubleshooting

[TODO: Add common issues here]
