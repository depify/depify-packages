#depify master package repo

To submit your own package to be included in the depify master repo;

### Step 1. [Fork](https://github.com/depify/depify-packages/fork) this repository

### Step 2. add .depify.xml describing your package, somewhere appropriate under [packages/master](https://github.com/depify/depify-packages/tree/master/packages/master) directory tree

### Step 3. validate .depify against [schema](https://raw.githubusercontent.com/depify/depify-packages/master/etc/depify.rng)

### Step 4. create a pull request with your change

Pull requests are typically approved immediately, though if there is a problem raise an [issue](https://github.com/depify/depify-packages/issues).

When pull request has been approved, a new [travis build](https://travis-ci.org/depify/depify-packages) will regenerate package metadata. The package should be available to the depify-client within a few minutes.
