def roll_dice(num)
  results = []
  num.times do
    results << rand(1..6)
  end
  results
end


# given number of dice, roll and pick highest
def roll_high(num)
  dice = roll_dice(num)
  dice.sort.last(2).sum
end

# given number of dice, roll and pick lowest
def roll_low(num)
  dice = roll_dice(num)
  dice.sort.first(2).sum
end

# given impact rating, give result
def roll(rating)
  if rating < 0
    roll_low(2 + rating.abs)
  else
    roll_high(2+rating)
  end
end

# run 1000 times for an impact rating.
# record results in a hash
def roll_results(rating, rolls)
  result_hash = {}
  rolls.times do
    res = roll(rating)
    result_hash[res] ||= 0
    result_hash[res] += 1
  end
  result_hash
end

#def result_str(res)
#  str = case res
#        when (10..12)
#          "P"
#        when (8..9)
#          "+"
#        when 7
#          "0"
#        when (5..6)
#          "-"
#        when (2..4)
#          "S"
#        end
#
#  #"#{str} %02d" % res
#  str
#end

# display result hash
#def display_impact(rating, rolls)
#  puts "Impact #{rating} ======="
#
#  data = roll_results(rating, rolls)
#
#  (2..12).to_a.reverse.each do |result|
#    occurrences = data[result]
#    prob = (occurrences.to_f / rolls)
#    bar_len = (prob * 50).floor
#    bar = ''
#    bar_len.times{ bar<<'X'}
#    puts "#{result_str(result)}  #{bar}    #{prob.round(2)}"
#  end
#end

def bar_prob(occurrences, total)
  prob = (occurrences.to_f / total)
  bar_len = (prob * 50).floor
  bar_str = ''
  bar_len.times{ bar_str<<'X'}
  [bar_str, prob]
end

def display_impact(rating, rolls)
  puts "Impact #{rating} ======="

  data = roll_results(rating, rolls)

  prog_occ = (10..12).sum{ |x| data[x] || 0 }
  bar, prob = bar_prob(prog_occ, rolls)
  puts "PROG  #{bar}     #{prob.round(2)}"

  pbut_occ = (8..9).sum{ |x| data[x] || 0 } + (data[7]/2)
  bar, prob = bar_prob(pbut_occ, rolls)
  puts "Pbut  #{bar}     #{prob.round(2)}"

  sbut_occ = (5..6).sum{ |x| data[x] || 0 } + (data[7]/2)
  bar, prob = bar_prob(sbut_occ, rolls)
  puts "Sbut  #{bar}     #{prob.round(2)}"

  setb_occ = (2..4).sum{ |x| data[x] || 0 }
  bar, prob = bar_prob(setb_occ, rolls)
  puts "SETB  #{bar}     #{prob.round(2)}"

  puts
end

# run for impact ratings -5 to 5
def run
  (-5..5).to_a.reverse.each do |i|
    display_impact(i, 10000)
  end
end

run
