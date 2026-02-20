Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '0',
      bottom: '0',
      left: '0',
      right: '0'
    },
    print_background: true,
    # Indispensable pour que Puppeteer attende que les images et polices soient chargées
    wait_until: 'networkidle2',
    launch_args: ['--no-sandbox', '--disable-web-security']
  }
end
