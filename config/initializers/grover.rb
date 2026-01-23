Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '10mm',
      bottom: '10mm',
      left: '10mm',
      right: '10mm'
    },
    print_background: true,
    # Indispensable pour que Puppeteer attende que les images et polices soient chargées
    wait_until: 'networkidle2'
  }
end
