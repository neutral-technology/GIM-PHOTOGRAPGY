class BrochureBlocksController < ApplicationController
  before_action :set_block
  # layout: 'application'

  def update
    @block.update!(content: params[:content])
    head :ok
  end

  def update_image
    @block.image.attach(params[:image])
    head :ok
  end

  # app/controllers/brochure_blocks_controller.rb
  def reorder
    @block = BrochureBlock.find(params[:id])
    new_position = params[:position].to_i
    
    # Get all blocks in the same page EXCEPT the one we are moving
    other_blocks = @block.brochure_page.blocks.where.not(id: @block.id).order(:position)
    
    # Insert the current block at the new position in the array
    all_blocks = other_blocks.to_a.insert(new_position - 1, @block)
    
    # Mass update positions
    all_blocks.each_with_index do |block, index|
      block.update_column(:position, index + 1)
    end

    head :ok
  end

  private

  def set_block
    @block = BrochureBlock.find(params[:id])
  end

  def block_params
    params.permit(:content, :position)
  end
end
