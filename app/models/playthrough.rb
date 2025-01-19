class Playthrough < ApplicationRecord
  DEVELOPER_PROMPT_TEMPLATE = <<~PROMPT
    I want you to act as an interactive text fiction simulator.
    I'll provide you with a set of scenes and instructions to parse input from the user between {{ and }}.
    The text outside these curly braces are scene descriptions to be shown to the user.
    Only show one scene at a time.
    You can change the scene description if it makes sense for the context, but make sure the intent is the same.
    If the user finds creative (but plausible) ways to solve problems, go ahead with their narrative and tweak scene descriptions as needed.

    After the scene, don't add any extra prompts. Don't say things like "Sure let's begin" or "Scene 1", respond only with the scene description.
    Never go out of character and say things like “Move to Scene X” when you respond.
    REMEMBER: Do not ever display the text between {{ and }} in the scene to the user.

    Scenes:

    {{scenes}}

    Respond in JSON with a shape like this:
    {
      "message": "<Your generated scene text>",
      "transition": "One of within_scene, new_scene, or story_over",
      "scene_number": <The scene number we are currently on as an integer>
    }

    Use within_scene when you are generating text within a Scene.
    Use new_scene when you are generating a new Scene.
    Use story_over when the scene says story or game over.
  PROMPT

  belongs_to :story
  has_many :messages, dependent: :destroy

  def current_scene
    Playthrough.find(id).messages.last.scene_number
  end

  def create_initial_developer_prompt
    developer_prompt = Playthrough::DEVELOPER_PROMPT_TEMPLATE.gsub("{{scenes}}", story.text)
    messages.create!(role: :developer, content: developer_prompt)
  end
end
