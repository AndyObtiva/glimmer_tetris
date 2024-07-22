# Copyright (c) 2021-2024 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative 'block'

class GlimmerTetris
  module View
    class Playfield
      include Glimmer::UI::CustomWidget
  
      options :game_playfield, :playfield_width, :playfield_height
  
      body {
        composite((:double_buffered unless OS.mac?)) {
          grid_layout {
            num_columns playfield_width
            make_columns_equal_width true
            margin_width BLOCK_SIZE
            margin_height BLOCK_SIZE
            horizontal_spacing 0
            vertical_spacing 0
          }
          
          playfield_height.times do |row|
            playfield_width.times do |column|
              block(game_block: game_playfield[row][column]) {
                layout_data {
                  width_hint BLOCK_SIZE
                  height_hint BLOCK_SIZE
                }
              }
            end
          end
        }
      }
  
    end
  end
end
