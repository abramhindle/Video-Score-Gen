       	sr = 22050
	kr = 220.5
	ksmps = 100
	nchnls = 1

      gkscale init 1
      gkmodkn init 1
      gkindex init 1
      gkq    init 1000
      gklpfreq init 1000
      gkcar  init 1
      gkpitch init 1
      gaout init 0

      gkContSineFreq init 0
      gkContSineAmp init 0

        gkred0 init 0
        gkred1 init 0
        gkred2 init 0 
        gkred3 init 0
        gkred4 init 0
        gkred5 init 0
        gkred6 init 0
        gkred7 init 0

        gkblue0 init 0
        gkblue1 init 0
        gkblue2 init 0 
        gkblue3 init 0
        gkblue4 init 0
        gkblue5 init 0
        gkblue6 init 0
        gkblue7 init 0

        gkgreen0 init 0
        gkgreen1 init 0
        gkgreen2 init 0 
        gkgreen3 init 0
        gkgreen4 init 0
        gkgreen5 init 0
        gkgreen6 init 0
        gkgreen7 init 0





; gkscale
        instr Scale
        p3 = 1/44100
        iv = p4
        gkscale = iv
        endin   

; gkmodkn
        instr Modkn
        p3 = 1/44100
        iv = p4
        gkmodkn = iv
        endin   

; gkq
        instr Q
        p3 = 1/44100
        iv = p4
        gkq = iv
        endin  

; gklpfreq
        instr Lpfreq
        p3 = 1/44100
        iv = p4
        gklpfreq = iv
        endin  
 
;gkcar 
       instr Car
       p3 = 1/44100
       iv = p4
       gkcar = iv
       endin  

;gkpitch
       instr Pitch
       p3 = 1/44100
       iv = p4
       gkpitch = iv
       endin  

;gkfmamp
       instr FMAmp
       p3 = 1/44100
       iv = p4
       gkfmamp = iv
       endin  



;gkContSineFreq
       instr ContSineFreq
       p3 = 1/44100
       iv = p4
       gkContSineFreq = iv
       endin  

;gkContSineAmp
       instr ContSineAmp
       p3 = 1/44100
       iv = p4
       gkContSineAmp = iv
       endin  
        
      
	instr	Sine
aamp    adsr (p3*0.1), (p3*0.1), 0.5, (p3*0.1)
a1	oscil	p4, p5, 1
        vincr	gaout,	a1*aamp
	endin

	instr	ContSine
kvib  oscil 1,cpspch(p5)/50,1
a1	oscil	gkContSineAmp, gkContSineFreq + 3*kvib, 1
	vincr	gaout,a1
	endin

        instr RedSet
        p3 = 1/44100
        ir0 = p4
        ir1 = p5
        ir2 = p6
        ir3 = p7
        ir4 = p8
        ir5 = p9
        ir6 = p10
        ir7 = p11
        gkred0 = ir0
        gkred1 = ir1
        gkred2 = ir2 
        gkred3 = ir3
        gkred4 = ir4
        gkred5 = ir5
        gkred6 = ir6
        gkred7 = ir7
        endin
        
        instr Red
        istart = 20
        iincr   = 20
kvib  oscil 1,cpspch(p5)/50,1
a0	oscil	gkred0, 0 * iincr + istart + 3*kvib, 1
a1	oscil	gkred1, 1 * iincr + istart + 3*kvib, 1
a2	oscil	gkred2, 2 * iincr + istart + 3*kvib, 1
a3	oscil	gkred3, 3 * iincr + istart + 3*kvib, 1
a4	oscil	gkred4, 4 * iincr + istart + 3*kvib, 1
a5	oscil	gkred5, 5 * iincr + istart + 3*kvib, 1
a6	oscil	gkred6, 6 * iincr + istart + 3*kvib, 1
a7	oscil	gkred7, 7 * iincr + istart + 3*kvib, 1
	vincr	gaout,4000*(a1+a2+a3+a4+a5+a6+a7)
	endin


        instr BlueSet
        p3 = 1/44100
        ir0 = p4
        ir1 = p5
        ir2 = p6
        ir3 = p7
        ir4 = p8
        ir5 = p9
        ir6 = p10
        ir7 = p11
        gkblue0 = ir0
        gkblue1 = ir1
        gkblue2 = ir2 
        gkblue3 = ir3
        gkblue4 = ir4
        gkblue5 = ir5
        gkblue6 = ir6
        gkblue7 = ir7
        endin
        
        instr Blue
        istart = 20
        iincr   = 20
kvib  oscil 1,cpspch(p5)/50,1
a0	oscil	gkblue0, 0 * iincr + istart + 3*kvib, 2
a1	oscil	gkblue1, 1 * iincr + istart + 3*kvib, 2
a2	oscil	gkblue2, 2 * iincr + istart + 3*kvib, 2
a3	oscil	gkblue3, 3 * iincr + istart + 3*kvib, 2
a4	oscil	gkblue4, 4 * iincr + istart + 3*kvib, 2
a5	oscil	gkblue5, 5 * iincr + istart + 3*kvib, 2
a6	oscil	gkblue6, 6 * iincr + istart + 3*kvib, 2
a7	oscil	gkblue7, 7 * iincr + istart + 3*kvib, 2
	vincr	gaout,4000*(a1+a2+a3+a4+a5+a6+a7)
	endin



        instr GreenSet
        p3 = 1/44100
        ir0 = p4
        ir1 = p5
        ir2 = p6
        ir3 = p7
        ir4 = p8
        ir5 = p9
        ir6 = p10
        ir7 = p11
        gkgreen0 = ir0
        gkgreen1 = ir1
        gkgreen2 = ir2 
        gkgreen3 = ir3
        gkgreen4 = ir4
        gkgreen5 = ir5
        gkgreen6 = ir6
        gkgreen7 = ir7
        endin
        
        instr Green
        istart = 20
        iincr   = 20
kvib  oscil 1,cpspch(p5)/50,1
a0	oscil	gkgreen0, 0 * iincr + istart + 3*kvib, 3
a1	oscil	gkgreen1, 1 * iincr + istart + 3*kvib, 3
a2	oscil	gkgreen2, 2 * iincr + istart + 3*kvib, 3
a3	oscil	gkgreen3, 3 * iincr + istart + 3*kvib, 3
a4	oscil	gkgreen4, 4 * iincr + istart + 3*kvib, 3
a5	oscil	gkgreen5, 5 * iincr + istart + 3*kvib, 3
a6	oscil	gkgreen6, 6 * iincr + istart + 3*kvib, 3
a7	oscil	gkgreen7, 7 * iincr + istart + 3*kvib, 3
	vincr	gaout,4000*(a1+a2+a3+a4+a5+a6+a7)
	endin


        instr 555
        kpitch = gkpitch*320*gkscale
        kcarrier = gkcar
af1      foscili gkfmamp, kpitch,      kcarrier, 5*gkmodkn, 5*gkindex, 1        
af2      foscili gkfmamp, 0.98*kpitch, kcarrier, 5*gkmodkn, 5*gkindex, 1        
af3      foscili gkfmamp, 1.04*kpitch, kcarrier, 5*gkmodkn, 5*gkindex, 1        
ar       lowpass2 af1+af2+af3, gklpfreq, gkq
         vincr gaout, ar
        endin

        instr Out
        out gaout
        clear gaout
        endin
