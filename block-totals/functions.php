<?php

use BookStack\Entities\Queries\EntityQueries;
use BookStack\Facades\Theme;
use BookStack\Theming\ThemeEvents;
use BookStack\Users\Models\User;
use BookStack\View\BaseViewBlock;
use BookStack\View\ViewBlockManager;

/**
 * Define our custom block for displaying total stats.
 * We extend the BaseViewBlock which implements the required ViewBlockInterface, and provides
 * a basis which may help with forward compatibility if the interface changes in the future.
 */
class TotalStatsBlock extends BaseViewBlock
{
    // Here we inject in the EntityQueries class, which BookStack will resolve automatically
    // when creating the block instance.
    public function __construct(
        protected EntityQueries $entityQueries,
    ) {
    }

    // We provide a unique ID for this block to distinguish it from other blocks.
    // This is used as the key when the block is configured as part of a layout.
    public static function getId(): string
    {
        return 'com.bookstackapp.hacks.total-stats-block';
    }

    // We return the label which will show for this block in the configuration UI.
    public static function getLabel(): string
    {
        return 'Instance Total Stats';
    }

    // We return the view name which will be used to render the block.
    // Here it's dynamic, based on the 'homeView' variable that's set when viewing home pages,
    // so we can use different views depending on homepage type.
    public function getView(array $viewData): string
    {
        $viewName = ($viewData['homeView'] ?? 'default') === 'default' ? 'home-default' : 'home-non-default';
        return "custom-block-totals.{$viewName}";
    }

    // We return all the total counts, so that our custom block view can use this data.
    public function getViewData(array $viewData): array
    {
        return [
            'totalUsers' => User::query()->count(),
            'totalBooks' => $this->entityQueries->books->visibleForList()->count(),
            'totalChapters' => $this->entityQueries->chapters->visibleForList()->count(),
            'totalPages' => $this->entityQueries->pages->visibleForList()->count(),
            'totalShelves' => $this->entityQueries->shelves->visibleForList()->count(),
        ];
    }
}

// We listen for the VIEW_BLOCKS_REGISTER event using the theme system which, when called,
// provides us a ViewBlockManager instance that we can use to register our custom block.
// We register the block twice, once for each homepage type.
Theme::listen(ThemeEvents::VIEW_BLOCKS_REGISTER, function (ViewBlockManager $manager) {
    $manager->register('home-default', 'right', TotalStatsBlock::class);
    $manager->register('home-non-default', 'unused', TotalStatsBlock::class);
});