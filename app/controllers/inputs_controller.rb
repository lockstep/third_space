class InputsController < ApplicationController

  def create
    input = Input.find_or_create_by(problem_id: input_params[:problem_id],
            lens: input_params[:lens], input_type: input_params[:input_type])
    input.update(input_params)
    render status: 200, head: nil
  end

  private

  def input_params
    params.require(:input).permit(:problem_id, :lens, :input_type, :input_text)
  end
end
