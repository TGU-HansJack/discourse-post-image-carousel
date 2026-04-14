import Component from "@glimmer/component";
import { action } from "@ember/object";
import { and, eq } from "truth-helpers";
import DModal from "discourse/components/d-modal";
import Form from "discourse/components/form";
import I18n, { i18n } from "discourse-i18n";

export default class CreateCarouselModal extends Component {
  formData = {
    enable_thumbs: false,
    enable_loop: false,
    enable_thumbs_loop: false,
    enable_autoplay: false,
    autoplay_interval: 5000,
  };

  constructor() {
    super(...arguments);
    const currentLocale = I18n.currentLocale();
    const localeTranslations = I18n.translations[currentLocale] || {};

    I18n.translations[currentLocale] = localeTranslations;
    localeTranslations.js ||= {};
    localeTranslations.js.composer ||= {};
    localeTranslations.js.composer.image_carousel_placeholder =
      settings.image_carousel_placeholder
        ? `<img src="${settings.image_carousel_placeholder}" />`
        : "";
  }

  @action
  handleSubmit(data) {
    const toolbarEvent = this.args.model.toolbarEvent;
    const enableThumbs = data.enable_thumbs === true;
    const enableLoop = data.enable_loop === true;
    const enableThumbsLoop = enableThumbs && data.enable_thumbs_loop === true;
    const enableAutoplay = data.enable_autoplay === true;
    const autoplayInterval =
      enableAutoplay && Number(data.autoplay_interval) > 0
        ? Number(data.autoplay_interval)
        : 5000;
    const insertImagesPlaceholder = I18n.t(
      themePrefix("carousel.modal.insert_images_placeholder")
    );

    if (settings.carousel_software === "Splide") {
      toolbarEvent.applySurround(
        `[wrap="Carousel" autoplay=${enableAutoplay} interval=${enableAutoplay ? autoplayInterval : false} loop=${enableLoop}]\n<!-- ${insertImagesPlaceholder} -->\n`,
        "\n[/wrap]",
        "image_carousel_placeholder"
      );
    } else {
      toolbarEvent.applySurround(
        `[wrap="Carousel" autoplay=${enableAutoplay} interval=${enableAutoplay ? autoplayInterval : false} loop=${enableLoop} thumbs=${enableThumbs} thumbs_loop=${enableThumbsLoop}]\n<!-- ${insertImagesPlaceholder} -->\n`,
        "\n[/wrap]",
        "image_carousel_placeholder"
      );
    }
    this.args.closeModal();
  }

  <template>
    <DModal
      class="create-carousel-modal"
      @title={{i18n (themePrefix "carousel.modal.modal_title")}}
      @subtitle={{i18n (themePrefix "carousel.modal.modal_subtitle")}}
      @bodyClass="create-carousel-modal__body"
      @closeModal={{@closeModal}}
    >
      <:body>
        <Form
          @data={{this.formData}}
          @onSubmit={{this.handleSubmit}}
          as |form transientData|
        >
          <div class="create-carousel-modal__layout">
            <section class="create-carousel-modal__section">
              <div class="create-carousel-modal__section-header">
                <h2 class="create-carousel-modal__section-title">
                  {{i18n (themePrefix "carousel.modal.display_section_title")}}
                </h2>
                <p class="create-carousel-modal__section-subtitle">
                  {{i18n
                    (themePrefix "carousel.modal.display_section_subtitle")
                  }}
                </p>
              </div>

              <div class="create-carousel-modal__fields">
                {{#if (eq settings.carousel_software "Swiper")}}
                  <div class="create-carousel-modal__field">
                    <form.Field
                      @name="enable_thumbs"
                      @title={{i18n
                        (themePrefix "carousel.modal.enable_thumbs_title")
                      }}
                      @description={{i18n
                        (themePrefix "carousel.modal.enable_thumbs_description")
                      }}
                      as |field|
                    >
                      <field.Toggle />
                    </form.Field>
                  </div>
                {{/if}}

                <div class="create-carousel-modal__field">
                  <form.Field
                    @name="enable_loop"
                    @title={{i18n
                      (themePrefix "carousel.modal.enable_loop_title")
                    }}
                    @description={{i18n
                      (themePrefix "carousel.modal.enable_loop_description")
                    }}
                    as |field|
                  >
                    <field.Toggle />
                  </form.Field>
                </div>

                {{#if
                  (and
                    (eq settings.carousel_software "Swiper")
                    transientData.enable_thumbs
                  )
                }}
                  <div class="create-carousel-modal__field">
                    <form.Field
                      @name="enable_thumbs_loop"
                      @title={{i18n
                        (themePrefix
                          "carousel.modal.enable_thumbs_loop_title"
                        )
                      }}
                      @description={{i18n
                        (themePrefix
                          "carousel.modal.enable_thumbs_loop_description"
                        )
                      }}
                      as |field|
                    >
                      <field.Toggle />
                    </form.Field>
                  </div>
                {{/if}}
              </div>
            </section>

            <section class="create-carousel-modal__section">
              <div class="create-carousel-modal__section-header">
                <h2 class="create-carousel-modal__section-title">
                  {{i18n (themePrefix "carousel.modal.playback_section_title")}}
                </h2>
                <p class="create-carousel-modal__section-subtitle">
                  {{i18n
                    (themePrefix "carousel.modal.playback_section_subtitle")
                  }}
                </p>
              </div>

              <div class="create-carousel-modal__fields">
                <div class="create-carousel-modal__field">
                  <form.Field
                    @name="enable_autoplay"
                    @title={{i18n
                      (themePrefix "carousel.modal.enable_autoplay_title")
                    }}
                    @description={{i18n
                      (themePrefix "carousel.modal.enable_autoplay_description")
                    }}
                    as |field|
                  >
                    <field.Toggle />
                  </form.Field>
                </div>

                {{#if transientData.enable_autoplay}}
                  <div class="create-carousel-modal__field">
                    <form.Field
                      @name="autoplay_interval"
                      @title={{i18n
                        (themePrefix
                          "carousel.modal.autoplay_interval_title"
                        )
                      }}
                      @description={{i18n
                        (themePrefix
                          "carousel.modal.autoplay_interval_description"
                        )
                      }}
                      as |field|
                    >
                      <field.Input @type="number" />
                    </form.Field>
                  </div>
                {{/if}}
              </div>
            </section>

            <p class="create-carousel-modal__hint">
              {{i18n (themePrefix "carousel.modal.insert_hint")}}
            </p>

            <form.Actions class="create-carousel-modal__actions">
              <form.Submit
                @translatedLabel={{i18n
                  (themePrefix "carousel.modal.submit")
                }}
              />
            </form.Actions>
          </div>
        </Form>
      </:body>
    </DModal>
  </template>
}
