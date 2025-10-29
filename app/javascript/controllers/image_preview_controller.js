import { Controller } from "@hotwired/stimulus"

// Se connecte à data-controller="image-preview"
export default class extends Controller {
  static targets = [ "input", "preview" ]

  // Cette méthode est appelée lorsque le champ de fichier change
  preview() {
    let input = this.inputTarget
    let preview = this.previewTarget

    // S'assure qu'un fichier a bien été sélectionné
    if (input.files && input.files[0]) {
      let reader = new FileReader();
      reader.onload = function(e) {
        // Affiche l'aperçu et met à jour sa source
        preview.classList.remove('d-none')
        preview.src = e.target.result
      }
      reader.readAsDataURL(input.files[0])
    }
  }
}
