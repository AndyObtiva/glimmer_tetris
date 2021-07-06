require 'glimmer-dsl-swt'
require 'glimmer-cp-bevel'

require_relative '../app/glimmer_tetris/model/tetromino'

include Glimmer

puts 'Building app icon...'
icon_block_size = 64
icon_bevel_size = icon_block_size.to_f / 25.to_f
icon_bevel_pixel_size = 0.16*icon_block_size.to_f
icon_size = 8
icon_pixel_size = icon_block_size * icon_size
tetric_icon_image = image(icon_pixel_size, icon_pixel_size) {
  icon_size.times { |row|
    icon_size.times { |column|
      colored = row >= 1 && column.between?(1, 6)
      color = colored ? color(([:white] + GlimmerTetris::Model::Tetromino::LETTER_COLORS.values).sample) : color(:white)
      x = column * icon_block_size
      y = row * icon_block_size
      bevel(x: x, y: y, base_color: color, size: icon_block_size)
    }
  }
}

puts 'Preparing app icon for saving to file...'
i = org.eclipse.swt.graphics.Image.new(display.swt_display, 512, 512)
gc = org.eclipse.swt.graphics.GC.new(i)
gc.drawImage(tetric_icon_image.swt_image, 0, 0)
il = ImageLoader.new
il.data = [i.image_data]

puts "Saving #{File.expand_path(File.join('..', 'package','linux', 'Glimmer Tetris.png'), __dir__)}"
il.save(File.expand_path(File.join('..', 'package','linux', 'Glimmer Tetris.png'), __dir__), swt(:image_png))
puts 'Done generating app icon.'
