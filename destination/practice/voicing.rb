["instruments","shaderview","experiments", "log","samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
shader :shader, "wave.glsl", "bits.vert", "points", 10
#shader :iSpaceLight, 0.4
#shader :iStarLight, 0.3
#shader [:iR, :iB, :iG], 3.0
#shader :iForm, 0.01
#shader :iDir, 1.0
#shader :iMotion, 0.0000001
shader :iFuzz, 0.03
#shader :iWave, 0.9
#shader :iSize, 100.9
#shader :iPointSize, 0.1
#shader :iDistort, 0.005
#@cells = 10000;
#shader :iDistort, 0.05
@cells ||= 100

with_fx(:reverb, room: 0.8, mix: 0.1, damp: 0.5) do |r_fx|
  live_loop :melody, sync: :slept_but do
    d = (ring
         :FS4, :FS3, :A4, :A3, :FS4, :FS3, :Cs4, :Cs3,
         :FS4, :FS3, :A4, :A3, :FS4, :FS3, :Cs4, :Cs3,
         :FS4, :FS3, :A4, :A3, :FS4, :FS3, :Cs4, :Cs3,
         :FS4, :FS3, :A4, :A3, :FS4, :FS3, :A4,  :A4,
         )
    sleep 0.25
    synth :dark_sea_horn, note: d.tick, noise1: 0.09, release: 1, cutoff: 70, amp: 2.9, attack: 1.0, decay: 0.25,    wave: 1.0
    synth :hollow, note: d.look, decay: 0.25, amp: 0.1, cutoff: (ring 80,90,100,110).tick(:c)
  end
end

live_loop :slept_but do #...
  d = (ring
       [(chord :FS3, :m),8],             #F A C
       [(chord :A3, :M, invert: 0), 8],  #A C E
       [(chord :D3, :M), 8],             #D F A
       [(chord :E3, :M), 8],             #E G B
       [(chord :D3, :M), 4],             #D F A
       [(chord :Cs3, :m, invert: 1), 4], #E Gs C
       [(chord :E3, :M, invert: 0), 4], #E G B
       )
  x= d.tick(:main)
  bass = (ring :Fs2, :E2, :A2, :Gs2, :D2, :CS2, :E2).tick(:bass)
  puts "Bass:#{note_inspect(bass)}"
  shader :vertex_settings,"points", [@cells += 100,10000].min
  puts @cells
  puts "chords:#{note_inspect(x[0])}"
  synth :dark_sea_horn, note: x[0][1], release: x[1], cutoff: 70, amp: 0.1,attack: 0.001, decay: 1.5
  sleep x[1]/8.0
  synth :dark_sea_horn, note: x[0][2], release: x[1], cutoff: 70, amp: 0.1,attack: 0.001, decay: 1.5
  sleep x[1]/8.0

  #synth :dark_sea_horn, note: x[0][0], release: x[1], cutoff: 70, amp: 0.1,attack: 0.001, decay: 1.1
  synth :dark_sea_horn, note: x[0][3], release: x[1], cutoff: 70, amp: 0.1,attack: 0.001, decay: 1.1

  at do
    sleep 1
    with_transpose 0 do
      #synth :fm, note: bass, decay: x[1]/2.0, cutoff: 80, amp: 0.5
      with_fx :slicer, phase: 0.25, smooth: 0.25, mix: 0.1 do
        with_transpose -12 do
          synth :dark_sea_horn, note: bass, decay: x[1][0], cutoff: 50, amp: 0.5
        end
      end
    end
  end

  h_note = (ring d.look(:main, offset: 1)[0],_,_).tick(:h)
  at do
    sleep x[1]-2
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      synth :hollow, note: h_note,    decay: x[1]/2.0, amp: 1.0, attack: 1.0
    end
  end

  with_transpose -12 do
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      synth :dsaw,    note: x[0][0], cutoff: 50, decay: 2.0, amp: 0.4
      synth :prophet, note: x[0][0], cutoff: 50, decay: 2.0, amp: 0.4
    end
  end

    #sample Corrupt[/instrument/,/fx/,/f#/,[0,1]].tick(:sample), cutoff: 60, amp: 0.5
      sleep x[1] - (x[1]/8.0)*2
  end

live_loop :do, sync: :slept_but do
  shader :decay, :iBeat, 2.0*2
  sample Fraz[/kick/,0], cutoff: 30, amp: 2.5
                    sleep 2
                    with_fx(:reverb, room: 0.6, mix: 0.7, damp: 0.5) do |r_fx|
                      sample Dust[/snare/,8], cutoff: 80, amp: 0.2
                    end
                    shader :growing_uniform, :iForm, rrand(0.01, 10.5), 0.1
                    shader :decay, :iDistort, rrand(0.005, 0.001), 0.0000001
                    if spread(1,4).tick(:S)
                      sleep 2-0.25
                      sample Mountain[/subkick/,1], cutoff: 50, amp: 1.5
                      sleep 0.25
                    else
                      sleep 2
                    end
                    end
