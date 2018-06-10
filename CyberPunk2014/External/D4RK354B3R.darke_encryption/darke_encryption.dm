//D4RK354B3R's Polyalphabetic Encryption Algorithm

//This is a polyalphabetic cipher that is not susceptible typical frequency analysis that can be performed by the average joe shmoe.
//Only someone more knowledgeable than I am about cryptography would be able to crack the cipher.

/*
An attack that could actually work is a letter frequency attack but only character by character and requires a very large
sample size of ciphertext (something to the tune of several hundred savefiles). I don't think any BYONDer would do it.

In other words, each character number (first second third fourth etc) has its own alphabet that is based upon the given cipher key.
var/cipherKey is just something that can be used to pad the original key and is intended to change from project to project.

* Something to note: There are some very minor collision vulnerabilities with this algorithm. I don't think they can be used as
the basis of a cryptographic attack unlike other polyalphabetic ciphers, and the only true vulnerability is this algorithm's
polyalphabetic nature: It's possible to derive each individual alphabet using frequency analysis.

Collision vulnerabilities with polyalphabetic ciphers are more common when the polyalphabetic cipher has smaller alphabets;
The alphabet I use is ~3x the size of the standard alphabet and can be easily expanded to include every ASCII or Unicode character.

An attack only needs to derive the first few alphabets;
further alphabets can be derived from the first few but it is impossible to determine the cipherkey, because of
the aforementioned problem with collisions.

* How to use: When creating a savefile, all values that you want to save need to be converted into a string.
The string is then encrypted using EnCrypt and the resulting ciphertext should be written into the savefile entry.

Afterwards, to load the savefile, use DeCrypt with the same cipher key to convert from ciphertext to plaintext and then convert
the plaintext to whatever primitive type it's supposed to be.

* Other notes: The cipher key should probably be salted with some stuff unique to each savefile (or even each savefile entry).
This can be something like the player's key or some thing unique to the savefile's context.

This will minimize the consistency in sample size of ciphertext that a cracker has access to.

It is also possible to regenerate the base alphabet between projects (but not between savefiles), so a successful attack on one
game's savefiles would need to be reperformed for any different game.

EXAMPLE:
//If I want to save a number, like money...

var/moneyCipher = EnCrypt("[mob.money]","[cipherKey][mob.key]["money"]")
savefile["money"]<<moneyCipher

//Then, to read from the savefile...

var/moneyCipher
savefile["money"]>>moneyCipher
mob.money = DeCrypt(moneyCipher,"[cipherKey][mob.key]["money"]")

*/

var
	cipherKey = "CyberpunkGameJam2014"

proc
	GenerateCipher()
		var/characters[] = chars.Copy()

		encrypt = chars.Copy()

		world<<"Generating new substitution associations"

		while(characters.len > 0)
			var/aa = pick(characters)

			var/bb = pick(characters)

			if(aa == bb) continue

			var/a = chars.Find(aa)
			var/b = chars.Find(bb)

			characters -= aa
			characters -= bb

			encrypt[aa] = b
			encrypt[bb] = a

		world<<"Completed new substitution associations, outputting..."

		var/string = "list("
		var/count = 0
		for(var/i in encrypt)
			count++
			string += "\"[html_encode(i)]\"=[encrypt[i]], "

			if(count % 10 == 0)
				string += "\\\n"
		string += ")"
		world<<string

	EnCrypt(string as text, key as text)

		var/shift
		var/odd = length(key)%2
		key = md5(key)

		for(var/a=1;a<=length(key),a++)
			var/i = copytext(key,a,a+1)
			shift += chars.Find(i)
		shift %= encrypt.len

		if(odd) shift*=-1

		var/delta

		var/ret

		for(var/i=1;i<=length(string),i++)
			delta += shift

			var/c = copytext(string,i,i+1)
			if(!(c in encrypt))
				ret += c
				continue

			var/char = (i%(length(cipherKey)))+1
			char = copytext(cipherKey,char,char+1)
			char = encrypt[char]

			var/index = encrypt[c] + delta + char
			index %= encrypt.len
			while(index <= 0) index += encrypt.len

			var/d = encrypt[index]

			ret += d

		return ret

	DeCrypt(string as text, key as text)

		var/shift
		var/odd = length(key)%2
		key = md5(key)

		for(var/a=1;a<=length(key),a++)
			var/i = copytext(key,a,a+1)
			shift += chars.Find(i)
		shift %= encrypt.len

		if(odd) shift*=-1

		var/delta

		var/ret

		for(var/i=1;i<=length(string),i++)
			delta += shift

			var/c = copytext(string,i,i+1)
			if(!(c in encrypt))
				ret += c
				continue

			var/char = (i%(length(cipherKey)))+1
			char = copytext(cipherKey,char,char+1)
			char = encrypt[char]

			var/cIndex = encrypt.Find(c)

			cIndex -= delta + char
			cIndex %= encrypt.len
			while(cIndex <= 0) cIndex += encrypt.len

			c = encrypt[cIndex]
			var/index = encrypt[c]

			var/d = encrypt[index]

			ret += d

		return ret