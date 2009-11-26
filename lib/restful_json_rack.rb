
class RestfulJsonMiddleware

  def initialize(app)
    @app = app
  end
  
  def call(env)
    request = Rack::Request.new(env)
    request.body.rewind
    body = request.body.read
    path_args = request.path.split("/").reject(&:blank?)
    if request.content_type =~ %r{application/json}
      send(request.request_method.downcase, path_args, body.blank? ? {} : JSON.parse(body))
    else
      @app.call
    end
  end

  def post(path_args, hash)
    model = model_class(path_args).new(hash)
    save(model)
  end

  def put(path_args, hash)
    model = model_instance(path_args)
    model.attributes = hash
    save(model)
  end

  def delete(path_args, hash)
    model_instance(path_args).destroy
    [200, {"Content-Type" => "application/json"}, ""]
  end

  def get(path_args, hash)
    if path_args.size == 1
      success(model_class(path_args).find(:all))
    else
      success(model_instance(path_args))
    end
  end

  def model_class(path_args)
    path_args.last.singularize.capitalize.constantize
  end

  def model_instance(path_args)
    id = path_args.pop
    model_class(path_args).find(id)
  end

  def save(model)
    if model.save
      success(model)
    else
      error(model.errors)
    end
  end

  def success(body)
    [200, {"Content-Type" => "application/json"}, body.to_json]
  end

  def error(body)
    [500, {"Content-Type" => "application/json"}, body.to_json]
  end
end
