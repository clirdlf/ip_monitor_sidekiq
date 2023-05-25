class Manifest
  def initialize(file)
    @manifest = Roo::Spreadsheet.open(file, headers: true)
  end

  def to_h
    {
      title:,
      program:,
      grant_number:,
      institution:,
      submission:,
      contact:,
      email:
    }
  end

  def grant_number
    @manifest.sheet(0).row(1)[1]
  end

  def program
    @manifest.sheet(0).row(2)[1]
  end

  def title
    @manifest.sheet(0).row(3)[1]
  end

  def institution
    @manifest.sheet(0).row(4)[1]
  end

  def contact
    @manifest.sheet(0).row(5)[1]
  end

  def email
    @manifest.sheet(0).row(6)[1]
  end

  def submission
    @manifest.sheet(0).row(7)[1]
  end

  def resources
    @resources = []
    @data_sheet ||= @manifest.sheet('MANIFEST DATA')
    @data_sheet.parse(headers: true, clean: true)
    # https://www.rubydoc.info/gems/roo/2.8.3#Accessing_rows_and_columns#Accessing_cells
    @data_sheet.each(
      restricted: 'RESTRICTED? (Y/N)',
      access_url: 'DIRECT URL TO FILE',
      access_filename: 'ACCESS  FILENAME',
      checksum: 'CHECKSUM',
      restricted_comments: 'COMMENTS ABOUT RESTRICTIONS',
      preservation_filename: 'PRESERVATION FILENAME',
      preservation_file_location: 'PRESERVATION FILE LOCATION'
    ) do |hash|
      @resources << hash
    end

    @resources
  end

  def validate!
    validate_program
    validate_submission_date
    validate_grant_number
    validate_resource_headers
  end

  private # maybe rethink this

  def validate_resource_headers
    @data_sheet ||= @manifest.sheet('MANIFEST DATA')
    @data_sheet.parse(headers: true, clean: true)

    headers = ['RESTRICTED? (Y/N)', 'DIRECT URL TO FILE', 'ACCESS  FILENAME', 'CHECKSUM', 'COMMENTS ABOUT RESTRICTIONS',
               'PRESERVATION FILENAME', 'PRESERVATION FILE LOCATION']
    headers.each do |header|
      raise ValidationError, "Missing Resource Header #{header}" unless @data_sheet.headers.to_h.key?(header)
    end
  end

  def validate_program
    programs = ['Recordings at Risk', 'Digitizing Hidden Special Collections and Archives']
    raise ValidationError, "Invalid program: #{program}" if programs.exclude?(program)
  end

  def validate_submission_date
    date = Chronic.parse(submission)
    raise ValidationError, 'Invalid submission date' if date.nil?
  end

  def validate_grant_number
    raise ValidationError, 'Invalid grant number' if grant_number.nil?
  end
end

class ValidationError < StandardError
  attr_reader :action

  def initialize(message, action = 'custom')
    super(message)

    @action = action
  end
end
