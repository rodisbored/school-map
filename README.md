# SchoolMap README

For this to work properly, you must have redis installed on your system.

You can install `redis` via brew if not previously installed: `brew install redis`.

Install all the necessary gems by running `bundle install`. This project uses Ruby 3.0.2, so you
may need to install it if it is not currently on your machine.

Once redis is installed, you can run the `schools:populate` rake task to pull in the latest list of
schools into the redis db. Run `rails schools:populate`. This is an optimization to have the map
load all locations on the first iteration.

If you do not run this step, the server will still operate on localhost, however it can take a
couple of minutes to load.

Run the rails server by executing `rails s`. Once the server is running, you can see the map at
`localhost:3000`.
