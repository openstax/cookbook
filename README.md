# OpenStax Book Recipes

Uses the `openstax_kitchen` gem to bake OpenStax books.

## Recipe File Structure

In this repo, we have (at least) one recipe for every book.  There's a `books/` directory in which we have subfolders, one for each book.  In those subfolders, we put an executable Ruby file, normally named `bake` but it could be anything.  (Later if you want to make a new recipe for the book you could name it `bake_new` or whatever in the same directory).

The executable `bake` Ruby scripts will typically have everything they need inside of them, e.g. they'll look like this:

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  gem 'openstax_kitchen', '2.0.0'
  gem 'slop', '4.8.2'
  gem 'byebug'
end

recipe = Kitchen::BookRecipe.new(book_short_name: :chemistry) do |doc|
  # ... RECIPE CODE HERE ...
end

opts = Slop.parse do |slop|
  slop.string '--input', 'Assembled XHTML input file', required: true
  slop.string '--output', 'Baked XHTML output file', required: true
end

puts Kitchen::Oven.bake(
  input_file: opts[:input],
  recipes: recipe,
  output_file: opts[:output]
)
```

Normal big Ruby projects have a `Gemfile` that is processed by the `bundler` gem to install and use all the right versions of any gems your code depends on.  Here we're using [bundler's ability](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html) to include a `gemfile` directly in the source code.  We're only using a few gems, so this is doable.  It is also makes the script nicely self-contained.  Because inline gem declarations like this don't have a `Gemfile.lock` that locks down the versions of gems (like other bigger Ruby projects), we want to make sure we use specific versions of gems e.g. `'1.0.1'` and not `'~> 1.0.0'`.

`Slop` is a simple command line argument parser.  Here it lets us call this `bake` script with `--input some_file.xhtml` and `--output other_file.xhtml` arguments that are passed into the `Kitchen::Oven.bake` call along with the recipe this script defines.  The `Kitchen::Oven.bake` method returns some profiling numbers that we output to the screen using `puts`.

## The main `bake` script

There's a top-level `bake` Bash script that calls the right scripts in the `books` folder based on the book slug.  E.g. if you call `./bake -b chemistry -i in.xhtml -o out.xhtml` this script will turn around and call `./books/chemistry/bake --input in.xhtml --output out.xhtml`.  Every time we add a new recipe, we'll need to update this top-level bake script so it knows how to call it.  This is also why the names of the scripts inside `/books` don't really matter, because the top-level `bake` script knows the names of the lower-level scripts.

## The `bake_legacy` script

This script can be used to build a book using legacy baking (e.g. `cnx-easybake`) given an old style CSS recipe file (an example of how to run this script with Docker can be found below).

## The `bake_root` script

This script can be used if you don't want to invoke `bake` (kitchen baking) or `bake_legacy` (`cnx-easybake` baking) directly, and instead want to use a single script that will adopt the appropriate process for the given book. When kitchen support is added for a book, this script should be updated accordingly (it will fallback to legacy baking for all unknown books). Also, this is the script that will be utilized by build pipelines (e.g. CORGI, web hosting, etc.), so it controls when a book is ready to switchover from legacy to kitchen baking in those environments.

## Docker

Development and execution can be done using Docker.

To build the docker image:

```bash
$> ./docker/build
```

Note this builds the runtime environment, suitable for running in production and some development work.  If you want a more full development environment, use VS Code using the remote containers extension.  This will build the development environment with a nice terminal, VS Code Live Share for pairing, etc.  To install the remote containers extension, visit `vscode:extension/ms-vscode-remote.remote-containers` in a browser.

This image includes all of the versions of gems used in each recipe so that they are available when used to bake files.  Notably, if you change the version of a gem in one of the executable recipes, you'll need to either rebuild the Docker image or call the `./scripts/install_used_gem_versions` script which scans through all of the recipes, installing the gem versions they specify in their inline gem file declarations.

To drop into the Docker container:

```bash
$> ./docker/bash
```

To use the Docker image to bake input XHTML files do the following (you can do it all on one line, just put it on multiple lines here to describe each part):

```bash
$> docker run --rm \                                                                # Remove container after the run
              -v $PWD:/files \                                                      # Mount the current host directory as /files so we can put files
                                                                                    #   in and get them out
              openstax/recipes:latest \                                             # The image ID (could use a specific tagged image instead of "latest")
              /code/bake -b chemistry -i /files/input.xhtml -o /files/baked.xhtml # The call to the main `bake` script
```

The above runs the baking in the latest (or some tagged) image.  If you want to run using your latest recipe code on your local machine, you can mount that code in the container by adding another `-v` argument: `-v /path/to/my/local/recipes:/code`.

Want to run the recipes and do interactive debugging?  Add the `-it` flags to the `docker run` call above.

### Other examples of using baking scripts with Docker

Given a directory with old style recipe files, the `bake_root` script can be invoked via Docker per the following example (this assumes you have `cnx-recipes` cloned to `/home/user`, but you can replace the path to wherever your style files are):

```bash
>$ docker run --rm \
    -v $PWD:/files \                                                                        # Mount the current directory as /files
    -v /home/user/cnx-recipes/recipes/output:/recipes \                                     # Mount the directory with old style recipes as /recipes
    openstax/recipes:latest \
    /code/bake_root -b chemistry -i /files/input.xhtml -r /recipes -o /files/baked.xhtml  # Invoke the `bake_root` script

Baking book 'chemistry' with kitchen
warning! could not find a replacement for '[link]' on an element with ID 'auto_f7224d2a-76cb-49f8-91ba-915271b912af_fs-idp283136'
Open:  0.000516647 s
Parse: 0.458909273 s
Bake:  13.600444227 s
Write: 0.298500043 s
```

If you want to bake a book with legacy baking which `bake_root` would otherwise route to `bake`, then you can utilize the `bake_legacy` script directly and pass the specific recipe file you desire:

```bash
>$ docker run --rm \
    -v $PWD:/files \                                                                         # Mount the current directory as /files
    -v /home/user/cnx-recipes/recipes/output:/recipes \                                      # Mount the directory with old style recipes as /recipes
    openstax/recipes:latest \
    /code/bake_legacy -i /files/input.xhtml -r /recipes/chemistry.css -o /files/baked.xhtml  # Invoke the `bake_legacy` script
```

## Rubocop

Rubocop is available inside the VSCode dev container.  Moreover, the `lefthook` gem enforces that Rubocop linting passes on modified files before pushes are allowed.  To test this without pushing run `lefthook run pre-push`.

## Using your local git clone of kitchen within the recipes devcontainer

If you put the absolute path of your machine's cloned kitchen folder into a `.devcontainer/kitchen_path` text file, e.g.:

```
/Users/staxly/dev/openstax/kitchen
```

the devcontainer in VS Code will mount that folder to `/code/kitchen`.  This will let you look at and edit the code from within your VS Code recipes workspace and will let you point recipes at this local code with

```ruby
gem 'openstax_kitchen', path: '/code/kitchen'
```

so that you can develop in both recipes and kitchen at the same time.  The kitchen folder has its own independent git state.

If you don't have a `kitchen_path` file, the devcontainer will mount a fake empty directory in `/tmp`.

If you use a line like the following in your recipe script to choose the kitchen gem version:

```ruby
gem 'openstax_kitchen', ENV['USE_LOCAL_KITCHEN'] ? { path: '/code/kitchen' } : '2.0.0'
```

And then call the recipe script prefixed with defining the `USE_LOCAL_KITCHEN` variable:

```bash
$ /code> USE_LOCAL_KITCHEN=1 ./books/chemistry2e/bake ...
```

then your recipe will use your local kitchen folder.  You can leave the `gem` line as is when you commit it, and in production runs since the `USE_LOCAL_KITCHEN` environment variable isn't set, the version number at the end will be used.

## Creating a new recipe

New recipes files are created in `books/{book-name}`. 

In order to run the new recipe via the bake script, the recipe must be added to [the `case` statement](https://github.com/openstax/recipes/blob/main/bake#L25), i.e.:

```bash
case "${book}" in
  chemistry) $DIR/books/chemistry/bake --input $input_file --output $output_file;;
  ... [other cases]
  {book-name}) $DIR/books/{book-name}/bake --input $input_file --output $output_file;;
  *) echo "Unknown book '${book}'"; exit 1;;
esac
```

Note that the recipe file must be made executable by running `chmod +x [path]` or `chmod 755 [path]` before it can be called by the bake script.

## Working on a recipe (converting from easybake)

When developing a recipe that already exists in easybake, the main goal is to produce output via the kitchen recipe that is identical to the easybake output. It's helpful to use VSCode's native differ or another diff tool to compare the output from the two methods of baking.

### Normalize

The kitchen output and the easybake output may have a number of unimportant differences such as in whitespace and the ordering of attributes. The `normalize` script tidies the HTML and puts all attributes in alphabetical order. Call this script on an HTML file by calling `ruby scripts/normalize [path]`.
