# grapple

First and foremost, I discourage you from using this software.

There are better password managers out there, written by smarter
people than I.

I like these:

* 1Password - https://1password.com/ - plays nice across OSes and
on various phones. It's first in this list because after playing
with a few, I thought it was the one that would get my parents to
use different passwords everywhere with minimal "what's my password?"
and "How do I work this thing?" phone calls.
* LastPass - https://www.lastpass.com/ - If I remember correctly,
the reason I like this is because it has a "change all my passwords
NOW" button? Because I think that's an essential feature. (1Password
lacks that feature, last I checked.)
* KeePass - https://keepass.info/ - various financial firms I've
worked at or consulted with like it (I think because it's good about
internally shared, but not *cloud* shared repos?). I think the UI/UX
is terrible, but I was using it on Windows and I'm a crank.
* DashLane - https://www.dashlane.com/ - beats me, man, they advertise
on podcasts I like, so...?
* Go read https://en.wikipedia.org/wiki/List_of_password_managers
for yourself.

But I don't want to use any of those, because, where it's even
feasible to audit their code, I don't have that kind of patience.
Also, I definitely don't want my passwords in anybody's cloud.

I keep my passwords in a PGP-encrypted file (at any given time: I'm
a bit out of date, but yes, I do read the GnuPG code I run), which
is sync'ed to computers that I own, but whose primary store is a
differently-encrypted (commercial, the one I use
currently - 2019-01 - touts "AES" and their code is not public, but
that's good enough for my purposes, like the trivially pickable
lock on my front door is good enough) USB mass storage device that's
hanging off my physical key chain any time it's not plugged into
the computer in front of me.

If you're my kind of paranoid, I guess this might be for you?

But, you know, "buyer" beware.

What's here at date of writing (2019-01-23) is *very* sparse, but
I'm actively working on it. If you're crazy enough to think this is
a thing you'd want to use, maybe take a glance at design.md for my
idea of what I want this to be.

I'm not morally opposed to things like iOS/Android apps, but that's
really not area of expertise. I already use this existing thing on my
existing iPhone via Shortcuts (neé Workflow), and that suits my
purposes fine.

As this is, it works for me on macOS, RHEL/CentOS, and NetBSD. Your
mileage will almost definitely very. If you have any problems, let
me know, with the caveat that I might not care.

## On Naming

When I first started to pull various inconsequential shell/Perl
scripts together into this thing, I dumped them into "grpw.pl", as
in "gr PassWord". Especially if you drop the ".pl", that's short to
type and tab-completes pleasantly on most modern Unix-like OSes, but
it doesn't sound like much.

My first pass for a name was "grope", as in "grope in one's memory
for a password", but that has obvious, fundamentally negative
alternate interpretations.

On the horns of that interpretation dilemma, I asked a few friends
who are smarter than I am for suggestions. Louisa, who takes care of
books for a living, got there first and best: grapple retains my "try to
remember" meaning, plausibly includes both "push new data in" and
"change extant data", and still tab-completes reasonably. Also, it
doesn't sound gross on its very face.

(I suppose I may need to print and then eat these words if some MMA
athlete is noisily and publicly exposed as a horrible human being,
but I hope that my saying this thing, right here, in public, might
buffer against that completely justified potential anger.)
