In light of [recent](http://www.codinghorror.com/blog/2010/12/the-dirty-truth-about-web-passwords.html)
[events](http://twitter.com/#!/abscondment/status/14525340114227201), I thought
it prudent to change our password storage to use bcrypt hashes. Salting md5sums
isn't the worst thing you could do, but it's really
[not as great as it might seem](http://codahale.com/how-to-safely-store-a-password/)
at first blush. Salted md5s are the leather jacket of bullet-stopping apparel:
demonstrably stronger than your plaintext cotton T-shirt, but nevertheless
insufficient for the task at hand.

Converting a production system to use bcrypt requires a few steps and some
sleight of hand. We can't encrypt the plain passwords because we no longer
have access to them. Instead, we could use the md5 with salt as a first pass
and apply bcrypt to that value.

The process goes like so:

 1. Add a new column to store the bcrypt hash.
 2. Deploy code that saves all of the md5sum, salt, and bcrypt hash when setting
    the password.
 3. Run a job that populates rows with an md5sum but no bcrypt hash. You'll hash
    the existing md5. You'll need to ensure a given md5 hasn't been changed since you read it out of the database.
 4. Deploy code that authenticates using the bcrypt hash. You'll check the
    bcrypt hash against md5sum(plaintext + salt).
 5. Once you're sure your bcrypt setup is working, deploy code to stop saving
    the md5sum. You can either stop using a salt for updated passwords or use a
    salt and store it. There's probably some deep cryptographic implication
    embedded in that decision, but analyzing it is beyond me. This step is the
    point of no return. Once your md5 column gets stale, you can't authenticate 
    using it.
 6. Drop the md5 column. Keep the salt, since you'll need it for authentication.

That wasn't so bad, was it? Step 3 even gave you a little first-hand
demonstration of one chief bcrypt feature: it takes a long time to generate
all of those hashes. No one will be brute-forcing your user base any time soon.
Just don't forget to properly secure your old backups... which you have, right?
