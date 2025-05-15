module Yass
  Config = Struct.new(
    :cwd,
    :src,
    :dest,
    :layouts,
    :templates,
    :clean,
    :include_drafts,
    :strip_index,
    :stdout,
    :stderr,
    :debug,
    keyword_init: true
  )
end
