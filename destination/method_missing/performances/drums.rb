set_volume! 0.1
_=nil
use_bpm 60
live_loop :thing do
  sleep 4
end
live_loop :third_voice, sync: :thing do
  tick
  n = (knit chord(:Fs3, :m), 2, chord(:E3, :M),1, chord(:B2, :m), 1, chord(:E3, :M), 1)
  #  synth :dark_sea_horn, note: n.tick[0], amp: 0.4, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*4, attack: 0.01
  synth :plucked, note: n.look[0], amp: 1.8, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*1, attack: 0.001
  at do
    4.times{
      synth :plucked, note: n.look[0], amp: 1.8, decay: (ring 0.25, 0.25, 0.25/2.0, 0.25).tick(:D)*2, attack: 0.00125, cutoff: (ring 50, 40, 100, 130 ).tick(:c)
      sleep 0.25
    }
  end
  sleep 2
end
live_loop :second_voice, sync: :thing do
  with_fx :distortion, mix: 0.7 do
    rand_reset
    p = [0.25, 0.5].shuffle
    with_fx :wobble, phase: 16, invert_wave: 0  do
      with_fx :slicer, phase: p[0], probability: 0.5  do
        synth :dark_sea_horn, note: chord(:E2, :M7)[0], amp: 2, decay: 4
        #synth :dark_ambience, note: chord(:E5, :M7), amp: 2, decay: 8
      end
      with_fx :slicer, phase: 0.25/2.0, probability: 0.5, invert_wave: 1  do
        #synth :dark_sea_horn, note: chord(:Fs2, :m11)[0], amp: 2, decay: 4
        #synth :dark_ambience, note: chord(:Fs5, :m11), amp: 2, decay: 4
      end
      with_fx :slicer, phase: p[1], probability: 0.5, invert_wave: 1  do
        synth :dark_sea_horn, note: chord(:D2, :M7)[0], amp: 2, decay: 4
        #synth :dark_ambience, note: chord(:D5, :M7), amp: 2, decay: 4
      end
    end
  end
  sleep 16
end
with_fx(:reverb, room: 0.9, mix: 0.3, damp: 0.5) do |r_fx|
  live_loop :hollower, sync: :thing do
    with_transpose (knit  7.0,0,0,3).rotate(0).tick(:t) do
      d = (ring
           [:e3, 1.0], [:e3, 0.5], [_, 0.5], [:a3, 0.5], [:e3, 1.0],  [:cs3, 0.5],    #:E :G :B 6th      :a :c :e  3th
           [:e3, 1],   [:e3, 0.5],  [_, 0.5], [:a3, 0.5], [:e3, 1.0],  [:cs3, 0.5],
           [:e3, 1],   [:e3, 0.5],  [_, 0.5], [:a3, 0.5], [:e3, 1.0],  [:cs3, 0.5],
           [_, 1],     [:e3, 0.5],  [:e3, 0.5],  [:a3, 0.5],  [:e3, 1.0], [:cs3, 0.5],
           ).rotate(3).tick(:n)
      d[1] = d[1]/4.0
      d4 = (knit [:e3, 1.0],1, [_, 0.5], 23,
            [:e3, 1.0],1, [_, 0.5], 23,
            [:e3, 1.0],1, [_, 0.5], 23,
            [:gs3, 1.0],1, [_, 0.5], 23
            ).rotate(3).tick(:v3)
       #synth :growl, note: d4[0], amp: 4.0, release: d4[1]*2

      score = (ring #7 per ring   2   2
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:fs3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],   #  E3 G#3   B3    C#4

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1], [:cs3, 0.5],[_, 0.5], [_, 0.5],   [:a3, 1.0], [:e3, 0.5],

            [_, 1],   [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [_, 1],  [_, 0.5],[_, 0.5], [_, 0.5], [_, 1.0], [_, 0.5],
            [:e3, 1],[:cs3, 0.5],[_, 0.5], [_, 0.5], [:fs3, 1.0], [:e3, 0.5],
            )
      d2 = score.tick(:n2)
      with_fx (ring :echo, :reverb, :echo, :echo).tick(:fx), phase: 1/1.0, decay: 2.0, mix: 0.0 do |fx|
        control fx, damp: rand
        with_transpose 12 do
          h = synth :hollow, note: d2[0], amp: 4.0, decay: d2[1]/8.0, note_slide: 0.125
n2 = score.look(:n2, offset: 0)
if n2[0] != nil && n2[0] != :r
at do
puts "------------->#{n2}"
sleep d2[1]/8.0
          #control h, note: n2[0]
        end
      end
      
      synth :hollow, note: (knit
                            _,16, :e3, 1, _, 7,
                            _,16, :gs3, 1, _, 7,
                            _,16, :e3, 1, _, 7,
                            _,16, :e3, 1, _, 7).tick(:d), amp: 2.0*0, decay: 1.0
      
    end
  end
  
  with_fx :distortion, mix: 0.4 do
    if d[0] == :fs4
      n = synth :gpa ,note: d[0],  amp: 1.0*8, release: d[1], note_slide: 0.25, attack: 0.0001, cutoff: 70, wave: 3
      #control n, note: :Fs3
    else
      #        n = synth :plucked, note: d[0],  amp: 0.5, release: d[1], attack: 0.0001, wave: 3
      n = synth :gpa, note: d[0],  amp: 3.0, release: d[1]*2, attack: 0.0001, wave: 4, cutoff: (ramp *(range 0,135, 1)).tick(:r)
      
      with_transpose -12 do
        #            n = synth :prophet, note: d[0],  amp: 1.0, release: d[1]*1, attack: 0.0001, wave: 4, cutoff: 80
      end
    end
    synth :hollow, note: (ring
                          _, _, _, _,
                          _, _, _, _,
                          _, _, _, _,
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
                             ).tick(:n3), amp: 3.0, release: d[1], cutoff: (range 80,100, 5).tick(:c2)
        sleep d[1]
      end
    end
  end

  live_loop :beat, sync: :thing do
   main_d = Fraz[/kick/,[2,2]].tick(:sample)
    6.times{
      sample main_d, cutoff: 130, amp: 4.0+rand
      #    sleep 1/2.0/2.0
      #   sleep 1/2.0/2.0
      sleep 1/2.0
    }
    sample Mountain[/ice/,[2,3]].tick(:sample), cutoff: 120, amp: 1.0
    sample main_d, cutoff: 120, amp: 4.0
    #    sleep 1/2.0/2.0
    #   sleep 1/2.0/2.0
    sleep 1/2.0/2.0
    sample Mountain[/ice/,[3,4]].tick(:sample), cutoff: 120, amp: 1.0
    sample main_d, cutoff: 120, amp: 4.0
    sleep 1/2.0/2.0
    sample main_d, cutoff: 135, amp: 4.0
    
    comment do
      2.times{
        sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 100, amp: 1.0
        #  sleep 1/2.0
        sleep 1/2.0
      }
      #     sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 100, amp: 1.0
      #      sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 135, amp: 1.0
      #     sleep 1/2.0
      #sleep  1/2.0/2.0
      #    sample Fraz[/kick/,[2,2]].tick(:sample), cutoff: 130, amp: 1.5
      #sleep 1/2.0/2.0
    end
  end
  
  live_loop :voice2, sync: :thing do
    n = (ring :Fs1, :A1, :Cs1, :D2, :E1).tick(:c)
    cue :fire if n == :Cs1 || n == :D2 || n == :E1
    with_fx :slicer, phase: 0.25, wave: 0 do
      #sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.2
      #synth :dark_sea_horn, note: (ring :Fs2, :A1, :Cs2, :D2, :E2).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
    end
    with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
    end
    sleep 4.0
  end
  
  live_loop :perc, sync: :thing do
    tick
    #sample CineElec[/extra/, /glass/].tick(:s), amp: 2.0, start: 0.21, finish: 0.27
    if (ring 1,1,0,1).look == 1
      sample CineElec[/Percussions/,/Pepper/, [0,1]].tick(:sample), amp: 0.5+rand*0.1
    end
    #if (ring 0,0,1,0, 0,0,0,0,  0,1,1,0, 0,0,0,0,  0,0,1,0,0,0,0,1,   0,1,1,0, 0,0,1,0).look == 1
    if (ring
        1,0,1,0, 1,0,1,0,  1,0,1,0, 1,0,1,0,
        1,0,1,0, 1,0,1,0,  1,0,0,1, 0,0,1,1).look == 1
      #sample Words[/beauty/,[3,3]].tick(:s), amp: 8.0, start: 0.1, finish: 0.11 + [0.04,0.0].choose
      sample CineElec[/one shots/,/hat/,[10,10,9]].tick(:hat), amp: 1.0
      #sample CineElec[/one shots/,/hat/,[10,10,3,10]].look, amp: 0.5,  cutoff: 100
    end
    if (ring
        0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
        0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0).look == 1
      sample Abstract[/one shots/,/layered/, /open/,2], amp: 0.5, start: 0.0
      
      p = (ring [rand*0.25,rand*0.5]).tick(:pos)
      with_fx :echo, feedback: rand*0.5, phase: 0.5, decay: 8, mix: [1.0,0.0].choose do
        sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0, start: p[0], finish: p[1])
        #sample Frag[/coil/,/f#m/,4], amp: 1.55
      end
    end
    sleep 0.25
  end
  
  live_loop :voice4, sync: :voice2 do
    sync :fire
    #sample(Words[/beauty/,[3,3]].tick(:s), amp: 2.0)
    
    8.times{
      sleep 0.25
      #sample Ether[/noise/,[0,0]].tick(:sample), cutoff: 130, amp: 0.1
    }
  end
