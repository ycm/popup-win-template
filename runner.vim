vim9script

import "./poputil.vim" as util

var lines = [
    '1. Nulla facilisi.', # {{{
    '2. Ut sed auctor neque.',
    '3. Sed a fringilla nunc.',
    '4. Donec ac laoreet erat.',
    '5. Proin sed vehicula dui.',
    '6. Vivamus vel maximus arcu.',
    '7. Fusce in sagittis sapien.',
    '8. Donec non tincidunt justo.',
    '9. Ut luctus sodales pulvinar.',
    '10. Curabitur ac posuere sapien.',
    '11. Pellentesque at feugiat lacus.',
    '12. Maecenas vestibulum tellus nisl.',
    '13. In dictum eget nisi quis tempor.',
    '14. In hac habitasse platea dictumst.',
    '15. Ut dictum eget purus ac ultrices.',
    '16. Morbi tincidunt cursus porttitor.',
    '17. Aenean convallis lacinia accumsan.',
    '18. Suspendisse ultrices pretium urna.',
    '19. In vel auctor ante, vel feugiat diam.',
    '20. Maecenas dictum ac turpis sed blandit.',
    '21. Integer tempor lorem ac feugiat cursus.',
    '22. Fusce non cursus magna, eu mattis odio.',
    '23. Proin mollis id velit sed pellentesque.',
    '24. Integer malesuada non tellus ac egestas.',
    '25. Mauris imperdiet ut magna quis interdum.',
    '26. Praesent id ultricies nunc, et viverra diam.',
    '27. Duis eget malesuada arcu, nec posuere sapien.',
    '28. Suspendisse fringilla gravida tortor ac rutrum.',
    '29. Fusce maximus finibus velit, vel convallis enim.',
    '30. Phasellus pharetra nulla et enim laoreet luctus.',
    '31. Suspendisse eget purus id lacus posuere laoreet.',
    '32. Mauris scelerisque libero id ipsum auctor tempor.',
    '33. Proin egestas sapien vitae facilisis pellentesque.',
    '34. Vestibulum efficitur lacus in lacus posuere rutrum.',
    '35. Ut tempor metus sapien, ac lacinia magna rhoncus eu.',
    '36. Sed volutpat tellus bibendum sollicitudin vulputate.',
    '37. Pellentesque auctor suscipit lacus sit amet eleifend.',
    '38. Vivamus mollis purus a mi convallis ultrices a id est.',
    '39. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    '40. Cras ac tortor tincidunt, efficitur diam eu, dictum orci.',
    '41. In euismod risus eget dui semper elementum et sit amet arcu.',
    '42. Morbi sit amet nunc non odio suscipit fermentum ac et lorem.',
    '43. Aliquam ultrices ante orci, ut scelerisque velit cursus vel.',
    '44. Pellentesque sed eros at lectus luctus tincidunt ut ac odio.',
    '45. Nulla luctus orci feugiat, gravida mauris vitae, luctus elit.',
    '46. Vivamus ultricies augue mauris, a vehicula orci elementum non.',
    '47. Nulla dolor quam, posuere nec sapien ac, maximus placerat enim.',
    '48. Cras ante ipsum, feugiat eget pellentesque ut, porta vitae eros.',
    '49. Aliquam vitae lectus ornare, interdum neque quis, viverra velit.',
    '50. Sed nunc nibh, accumsan vel congue quis, imperdiet sit amet orci.' # }}}
]

var win = util.SmartScrollPopup.new(lines[: 19])

command! Pop win.Show()

nnoremap <silent> <leader>p :Pop<cr>
