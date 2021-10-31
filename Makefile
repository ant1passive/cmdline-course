BOOKS=alice christmas_carol dracula frankenstein heart_of_darkness life_of_bee moby_dick modest_propsal pride_and_prejudice tale_of_two_cities ulysses

STRIPPEDBOOKS=$(BOOKS:%=data/%.no_md.txt)
FREQLISTS=$(BOOKS:%=results/%.freq.txt)
SENTEDBOOKS=$(BOOKS:%=results/%.sent.txt)
PARSEDBOOKS=$(BOOKS:%=results/%.parsed.txt)

# Using $(CATENATE) as recipe didn't work, even with escaping the dollar signs
#CATENATE='cat $^ > $@'

all: $(FREQLISTS) $(SENTEDBOOKS) $(PARSEDBOOKS) results/all.freq.txt results/all.sent.txt

clean:
	rm -f results/* data/*no_md.txt

%.no_md.txt: %.txt
	python3 src/remove_gutenberg_metadata.py $< $@

results/%.freq.txt: data/%.no_md.txt
	src/freqlist.sh $< $@

results/%.sent.txt: data/%.no_md.txt
	src/sent_per_line.sh $< $@

# This target should use $(BOOKS) directly, as per Question 12.
# However, getting targets all.freq.txt and all.sent.txt
# to work properly took so much tinkering that I had to define
# STRIPPEDBOOKS to clear things up.
data/all.no_md.txt: $(STRIPPEDBOOKS)
	cat $^ > $@

results/all.freq.txt: data/all.no_md.txt
	src/freqlist.sh $< $@

results/all.sent.txt: $(SENTEDBOOKS)
	cat $^ > $@

results/%.parsed.txt: results/%.sent.txt
	python3 src/parse.py $< $@
