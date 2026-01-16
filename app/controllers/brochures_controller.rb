class BrochuresController < ApplicationController
  def show
    @brochure = Brochure.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "brochure-#{@brochure.id}",
              layout: "pdf",
              margin: { top: 10, bottom: 10 },
              page_size: "A4"
      end
    end
end

end