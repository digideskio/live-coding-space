set_volume! 1.0
_=nil
use_bpm 60
live_loop :bazz, sync: :thing do
  _=[[], 0.125]
  b = (ring  #1.75       0.875 per line         # 0.4375
       [chord(:A2, :M, invert: 0),   1.0],      [[], 0.5], [[:Cs2], 0.5], #0.5+0.125
       [chord(:Cs3, :m),              1.0],     [[], 0.5], [[:A1], 0.5],
       [chord(:A2,  :M),             0.75],     [[], 1.0], [[:B1], 0.25],
       [chord(:Fs2, :m,  invert: 3), 0.75],     [[], 1.0], [[], 0.25]
       ).tick(:n2)
  with_transpose 0*12 do
    n = (ring
         chord(:Fs2, :m), :FS2,
         :A2, :A2,
         :CS3, :A2,
         :D2, :E2)
    b = n.tick(:bass)
    #    synth :gpa,  note: b , amp: 2.1, decay: 3.5 , attack: 0.1, release: 0.25, sustain: 0.01, wave: 4, amp: 2.0
  end
  sleep 4
end
live_loop :second_voice, sync: :thing do
  with_fx :distortion, mix: 0.7 do
    with_fx :wobble, phase: 16, invert_wave: 0  do
      with_fx :slicer, phase: 0.25, probability: 0.5  do
        #        synth :dark_ambience, note: chord(:Gs6, :m13), amp: 4, decay: 8
      end
    end
  end
  sleep 16
end

live_loop :fourth_voice, sync: :thing do
  sleep 4
  4.times{
    #    synth :plucked, note: (ring :E5, :E4).tick(:d), amp: 0.2, decay: 0.25, pan: [0.25,-0.25].choose
    sleep 1/2.0/2.0
  }
end

live_loop :third_voice, sync: :thing do
  n = (knit chord(:A2, :M), 2, chord(:E2, :M),1, chord(:B2, :m), 1, chord(:E2, :M), 1)
  # synth :dark_sea_horn, note: n.tick[0], amp: 0.2, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.01
  # synth :plucked,       note: n.look, amp: 1.0, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.25
  sleep 2
end

with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    with_transpose (knit 0,3, 7.0,0).tick(:t) do
      d = (ring
           #     [:fs4, 1], [:fs3, 0.5],[_, 0.5], [:A3, 0.5], [:fs3, 1.0], [:Cs3, 0.5]
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [:Cs3, 0.5],
           [:e3, 1], [:e3, 0.5],[_, 0.5], [:A3, 0.5], [:e3, 1.0], [_, 0.5],
           [_, 1],[:e3, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],
           ).tick(:n)
      #d = (ring  [:fs4, 1], [:gs3, 0.5], [_, 0.5], [:A3, 0.5], [:gs3, 1.0], [:Cs3, 0.5]).tick
      d[1] = d[1]/4.0

      d2 = (ring #7 per ring   2   2
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:a3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:a3, 1], [:cs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

          [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
           [:a3, 1], [:gs4, 0.5],[_, 0.5], [_, 0.5],   [:gs3, 1.0], [:Cs3, 0.5],

           ).tick(:n2)

  with_transpose 12 do
    #synth :hollow, note: d2, amp: 16.0
  end

      with_fx :distortion, mix: 0.5 do

        if d[0] == [:fs4]
          n = synth :gpa ,note: d[0],  amp: 1.0*1, release: d[1], note_slide: 0.25,attack: 0.0001, cutoff: 80
          control n, note: :Fs3
          #n = synth :plucked, note: (knit :f4,1,_,3).tick(:sour),  amp: 0.5*1, release: d[1]*4, note_slide: 0.25,attack: 0.0001
        else
          n = synth :gpa, note: d[0],  amp: 1.3, release: d[1]*2, attack: 0.0001, wave: 4, cutoff: (ramp *(range 0,130, 1)).tick(:r2)
        end
        synth :hollow, note: (ring
                              #   _, _, _, _,
                              #   _, _, _, _,
                              #   _, _, _, _,
                              :Cs4, :E5, :FS3, :FS3,
                              :Cs4, :E5, :CS5, :CS4,
                              :Cs4, :E5, :FS4, :FS4,

                              :Cs4, :E5, :FS3, :FS3,
                              :Cs4, :E5, :CS5, :CS4,
                              :Cs4, :E5, :GS3, :GS3,


        ).tick(:n2), amp: 0.0, release: d[1]/4.0, cutoff: (range 80,100, 5).tick(:c)
    end
    _=:r
    synth :blade, note: (ring
                         [:gs4,:Fs4,:Cs4,:E4].choose, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         _, _, _, _,
                         ).tick(:n3), amp: 0.5, release: d[1], cutoff: (range 80,100, 5).tick(:c2)
    sleep d[1]
  end
end
end

with_fx :reverb do
  live_loop :thing do
    _=nil
    l = (ring 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5).tick/4.0
    n = (ring
         :fs3 #:e2, :gs3 #, :fs2, :e2# :Gs4, :fs3
         ).tick(:note)
    n2 = (ring
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,:FS4, _, _,
          ).tick(:note2)
    with_transpose [5,0].choose do
      # synth :hollow, note: n2, release: 1.0, amp: 4.0*1
    end
    
    with_fx :distortion, mix: 0.2, distort: (range 0.1, 0.7, 0.1).tick(:r) do
      with_fx :bitcrusher, bits: (range 4,16,1).tick(:b), mix: 0.2 do
        #   synth :dsaw, note: n, release: l, cutoff: (rrand 80,90), amp: 0.6*0.4
      end
    end
    #synth :tri, note: n, release: l, amp: 1 *1
    #synth :gpa, note: n, release: l*2, amp: 1 *1
    sleep l
  end
end

live_loop :beat, sync: :thing do
  sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 1.0
  sleep 1/2.0/2.0
  sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 130, amp: 0.9
  sleep 1/2.0/2.0
  #sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 130, amp: 0.8
  #sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
  sleep 1/2.0
  sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 1.0
  sleep 1/2.0
  #sample Fraz[/kick/,[2,2,2,2]].tick(:sample), cutoff: 130, amp: 0.8
  #sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
  sleep 1/2.0
end

live_loop :voice2, sync: :thing do
  n = (ring :Fs1, :A1, :Cs1, :D2, :E1).tick(:c)
  cue :fire if n == :Cs1 || n == :D2 || n == :E1
  with_fx :slicer, phase: 0.25, wave: 0 do
    #sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.2
    #synth :dark_sea_horn, note: (ring :Fs2, :A1, :Cs2, :D2, :E2).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
    #synth :dark_sea_horn, note: (ring :Fs1, :A1, :Cs1, :D2, :E1).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  sleep 4.0
end

live_loop :perc, sync: :thing do
  tick
  #sample CineElec[/extra/, /glass/].tick(:s), amp: 1.0, start: 0.21, finish: 0.27
  if (ring 0,1,1).look == 1
    #sample CineElec[/Percussions/,/Pepper/].tick(:sample), amp: 0.5
  end
  if (ring 1,1,0,0,).look == 1
    #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
    sample CineElec[/hat/,[2,3]].tick(:s), amp: 0.25, start: 0.21, finish: 0.27
  end
  
  if (ring 0,0,1,0, 0,0,1,0, 0,0,1,0).look == 1
    #sample Words[/beauty/,[3,3]].tick(:s), amp: 4.0, start: 0.21, finish: 0.27
    sample CineElec[/hat/,[14,14]].tick(:s2), amp: 0.25
  end
  sleep 0.25
  
  if spread(4,8).look
    # sample CineElec[/hat/,[0,1]].tick(:s), amp: 0.1
  end
  p = [[4,4],[6,6]].shuffle
  #  s = (ring [0.0, 0.01],[0.0, 0.05],[0.0, 0.05], [0.8, 0.9]).tick(:start)
  # if spread(*p[0]).tick
  #  sample Frag[/./].tick(:sample),  amp: 0.6, pan: (ring 0.25, -0.25).tick(:p)
  # end
  if spread(*p[1]).look
    
    #sample CineElec[/f#m/, /WrongPiano/].tick(:wp), amp: 1.0,
    # rpitch: (ring 0.0, 0.0, 0.0, 1.0).tick(:p)
  end
  
  
end

live_loop :voice4, sync: :voice2 do
  sync :fire
  8.times{
    sleep 0.25
    sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.1
  }
end

live_loop :hats, sync: :thing do
  sleep 0.25
  if spread(7,11).tick
    #     sample Dust[/hat/,[0,0,0,1]].tick(:sample), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
  if spread(3,7).look
    #    sample Dust[/hat/,[1,2]].tick(:sample2), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
  if spread(1,16).look
    #   sample Dust[/hat/,/open/,0..1].tick(:sample3), cutoff: 85+rand, amp: 0.9, start: rrand(0.0,0.05)
  end
end
