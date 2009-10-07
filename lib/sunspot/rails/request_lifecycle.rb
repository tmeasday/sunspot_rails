module Sunspot #:nodoc:
  module Rails #:nodoc:
    # 
    # This module adds an after_filter to ActionController::Base that commits
    # the Sunspot session if any documents have been added, changed, or removed
    # in the course of the request.
    #
    module RequestLifecycle
      class <<self
        def included(base) #:nodoc:
          base.after_filter do
            begin
              if Sunspot::Rails.configuration.auto_commit_after_request?
                Sunspot.commit_if_dirty
              elsif Sunspot::Rails.configuration.auto_commit_after_delete_request?
                Sunspot.commit_if_delete_dirty
              end
            rescue RSolr::RequestError => e
              raise e unless Sunspot::Rails.configuration.ignore_errors?
              ::Rails.logger.warn "Sunspot::Rails Error:: #{e}"
            end
          end
        end
      end
    end
  end
end
