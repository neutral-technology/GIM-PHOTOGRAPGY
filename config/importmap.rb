# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.1.3-4/app/assets/javascripts/rails-ujs.esm.js'
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'alpinejs', to: 'https://unpkg.com/alpinejs@3.x.x/dist/module.esm.js'
pin '@alpinejs/persist', to: 'https://unpkg.com/@alpinejs/persist@3.x.x/dist/module.esm.js'
pin '@alpinejs/collapse', to: 'https://unpkg.com/@alpinejs/collapse@3.x.x/dist/module.esm.js'
pin "qr-scanner", to: "https://cdn.jsdelivr.net/npm/qr-scanner@1.4.2/qr-scanner.min.js"
pin "qr-scanner-worker", to: "https://cdn.jsdelivr.net/npm/qr-scanner@1.4.2/qr-scanner-worker.min.js"
pin 'custom' # @0.0.0

# 🟢 ADD THIS LINE BELOW
# config/importmap.rb
# config/importmap.rb
# pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/index.js"
# pin "fs" # @2.1.0
# pin "path" # @2.1.0
