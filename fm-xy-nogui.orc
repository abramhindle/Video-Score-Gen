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
kvib poscil 1,cpspch(p5)/50,1
a1	oscil	gkContSineAmp, gkContSineFreq + 3*kvib, 1
	vincr	gaout,a1*aamp
	endin


        instr 555
        kpitch = gkpitch*320*gkscale
        kcarrier = gkcar
af1      foscili 1000, kpitch,      kcarrier, 5*gkmodkn, 5*gkindex, 1        
af2      foscili 1000, 0.98*kpitch, kcarrier, 5*gkmodkn, 5*gkindex, 1        
af3      foscili 1000, 1.04*kpitch, kcarrier, 5*gkmodkn, 5*gkindex, 1        
ar       lowpass2 af1+af2+af3, gklpfreq, gkq
         vincr gaout, ar
        endin

        instr Out
        out gaout
        clear gaout
        endin
