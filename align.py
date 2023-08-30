def optAlign( sel1, sel2 ):
        """
        @param sel1: First PyMol selection with N-atoms
        @param sel2: Second PyMol selection with N-atoms
        """

        # make the lists for holding coordinates
        # partial lists
        stored.sel1 = []
        stored.sel2 = []
        # full lists
        stored.mol1 = []
        stored.mol2 = []

        # -- CUT HERE
        sel1 = sel1 + " and N. CA"
        sel2 = sel2 + " and N. CA"
        # -- CUT HERE

        # This gets the coordinates from the PyMOL objects
        cmd.iterate_state(1, selector.process(sel1), "stored.sel1.append([x,y,z])")
        cmd.iterate_state(1, selector.process(sel2), "stored.sel2.append([x,y,z])")

        # ...begin math that does stuff to the coordinates...
        mol1 = cmd.identify(sel1,1)[0][0]
        mol2 = cmd.identify(sel2,1)[0][0]
        cmd.iterate_state(1, mol1, "stored.mol1.append([x,y,z])")
        cmd.iterate_state(1, mol2, "stored.mol2.append([x,y,z])")
        assert( len(stored.sel1) == len(stored.sel2))
        L = len(stored.sel1)
        assert( L > 0 )
        COM1 = numpy.sum(stored.sel1,axis=0) / float(L)
        COM2 = numpy.sum(stored.sel2,axis=0) / float(L)
        stored.sel1 = stored.sel1 - COM1
        stored.sel2 = stored.sel2 - COM2
        E0 = numpy.sum( numpy.sum(stored.sel1 * stored.sel1,axis=0),axis=0) + numpy.sum( numpy.sum(stored.sel2 * stored.sel2,axis=0)
,axis=0)
        reflect = float(str(float(numpy.linalg.det(V) * numpy.linalg.det(Wt))))
        if reflect == -1.0:
                S[-1] = -S[-1]
                V[:,-1] = -V[:,-1]
        RMSD = E0 - (2.0 * sum(S))
        RMSD = numpy.sqrt(abs(RMSD / L))
        U = numpy.dot(V, Wt)
        # ...end math that does stuff to the coordinates...

        # update the _array_ of coordinates; not PyMOL the coords in the PyMOL object
        stored.sel2 = numpy.dot((stored.mol2 - COM2), U) + COM1
        stored.sel2 = stored.sel2.tolist()

        # This updates PyMOL.  It is removing the elements in 
        # stored.sel2 and putting them into the (x,y,z) coordinates
        # of mol2.
        cmd.alter_state(1,mol2,"(x,y,z)=stored.sel2.pop(0)")

        print ("RMSD=%f" % RMSD)

        cmd.orient(sel1 + " and " + sel2)

# The extend command makes this runnable as a command, from PyMOL.
cmd.extend("optAlign", optAlign)