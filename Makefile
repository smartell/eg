#Makefile for building and running the LSMR model on a Linux or Mac OSX
EXEC=eg
TPL=$(EXEC).tpl
DAT=$(EXEC).dat


all: $(EXEC) $(EXEC).rep 

$(EXEC): $(TPL)
	admb $(EXEC)

$(EXEC).rep: $(TPL) $(DAT)
	./$(EXEC) -ind $(DAT)

mcmc: runmc mceval 

runmc: $(EXEC) $(EXEC).rep
	./$(EXEC) -ind $(DAT) -mcmc 500000 -mcsave 200 -nosdmcmc

mceval: $(EXEC).psv
	./$(EXEC) -ind $(DAT) -mceval


dust:
	rm -f *.log *.rpt *.htp  variance *.bar *.mcm *.[bpr][0123456789]*

clean:
	rm -f $(EXEC) *.eva *.log *.rpt *.htp *.cor *.par *.r* *.p0* *.b*
	rm -f *.rep *.bar *.psv *.std $(EXEC).cpp admodel.* variance

buglike: run 

run:
	./$(EXEC) -ind $(DAT) -mcmc 100000 -mcsave 100 -noest -ainp eg.pin1 -mcseed 121
	cp eg.psv eg.psv1
	./$(EXEC) -ind $(DAT) -mcmc 100000 -mcsave 100 -noest -ainp eg.pin2
	cp eg.psv eg.psv2
	./$(EXEC) -ind $(DAT) -mcmc 100000 -mcsave 100 -noest -ainp eg.pin3 -mcseed 444
	cp eg.psv eg.psv3
	./$(EXEC) -ind $(DAT) -mcmc 100000 -mcsave 100 -noest -ainp eg.pin4
	cp eg.psv eg.psv4


