Title: previously created user doesn't exist?

In the spitit of kairos being immutable, and considering I don't see /etc/passwd included in the COS_PERSISTENT partition, I'm assuming users/groups are reconstructed after every boot. This is great, what I'm confused about is how user lifecycle management is support to work declaratively.

There seems to be 4 ways to instantiate a user:
1. top level `users` entry in your cloud-config file
2. `users` entry in one of the stages layers of your cloud-config
3. an `ensure_entities` statement at any of the stages layers
4. baked into the container image

A few questions:

* When a user is declared at the top level of a cloud-config file, is this applied at every boot or just the initial install?

The docs state that if you want to add a user post-install that you should add a `users` entry in the initramfs stage. This to me implies that all `stages` are run at every boot, and that the top-level declarations are only pertinent for the initial install. If this is the case, why not skip the top-level entirely and only put the `users` entry in your chosen `stage`? I initially did this but it seems that not having a top-level users declaration isn't valid syntax (`kairos-agent validate` states the rendered json is invalid).

* What takes precedence in cloud config `users` or `ensure_entities`? If both have overlapping entries how are these handled?

* When can I expect users declared at the top level to be available?

The following error is a step in my cloud config that runs at the fs stage.
```bash
Oct 12 04:46:06 nas kairos-agent[1791]: ERRO[2023-10-12T04:46:06Z] chown: invalid user: ‘clayton:clayton’
Oct 12 04:46:06 nas kairos-agent[1791]: : failed to run chown -R clayton:clayton /scratch/dotfiles && su clayton -c "HOME=/home/clayton /scratch/dotfiles/install" >
```
I assumed that fs was the "final" stage, but it appears that users aren't available on the system yet? When can I assume they'll be available? If I want do user related things do I have to add an `ensure_entities` or `users` in a prior stage (or at least before the action on the same stage)?
