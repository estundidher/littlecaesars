Paperclip::Attachment.default_options.merge!(
  url:                  ':s3_domain_url',
  path:                 '/:class/:attachment/:id/:style/:filename',
  storage:              :s3,
  s3_protocol:          :https,
  s3_credentials:       Rails.configuration.aws
)