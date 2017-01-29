class InputsController < ApplicationController

  def create
    input = Input.find_or_create_by!(problem_id: input_params[:problem_id],
            lens: input_params[:lens], input_type: input_params[:input_type])
    input.update(input_params)
    render status: 200, json: ''
  end

  def input_text
    render status: 200, json: Input.find_by(problem_id: params[:problem_id],
      lens: params[:lens], input_type: params[:input_type]).try(:input_text).try(:to_json)
  end

  def count
    render status: 200, json: Input.where(problem_id: params[:problem_id])
                              .where(input_type: [:result, :solution]).count
  end

  private

  def input_params
    params.require(:input).permit(:problem_id, :lens, :input_type, :input_text)
  end
end
