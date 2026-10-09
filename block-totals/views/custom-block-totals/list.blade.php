<div class="page icon-list-item no-hover">
    <span role="presentation" class="icon text-page">@icon('page')</span>
    <div class="content">
        <span class="icon-list-item-name break-text">{{ number_format($totalPages) }} Pages</span>
    </div>
</div>

<div class="chapter icon-list-item no-hover">
    <span role="presentation" class="icon text-chapter">@icon('chapter')</span>
    <div class="content">
        <span class="icon-list-item-name break-text">{{ number_format($totalChapters) }} Chapters</span>
    </div>
</div>

<a href="{{ url('/books') }}" class="book icon-list-item" style="color: inherit;">
    <span role="presentation" class="icon text-book">@icon('book')</span>
    <div class="content">
        <span class="icon-list-item-name break-text" style="color: inherit;">{{ number_format($totalBooks) }} Books</span>
    </div>
</a>

<a href="{{ url('/shelves') }}" class="bookshelf icon-list-item" style="color: inherit;">
    <span role="presentation" class="icon text-bookshelf">@icon('bookshelf')</span>
    <div class="content">
        <span class="icon-list-item-name break-text" style="color: inherit;">{{ number_format($totalShelves) }} Shelves</span>
    </div>
</a>

@if(userCan(\BookStack\Permissions\Permission::UsersManage))
    <a href="{{ url('/settings/users') }}" class="icon-list-item" style="color: inherit;">
        <span role="presentation" class="icon">@icon('user')</span>
        <div class="content">
            <span class="icon-list-item-name break-text" style="color: inherit;">{{ number_format($totalUsers) }} Users</span>
        </div>
    </a>
@else
    <div class="icon-list-item no-hover">
        <span role="presentation" class="icon">@icon('user')</span>
        <div class="content">
            <span class="icon-list-item-name break-text">{{ number_format($totalUsers) }} Users</span>
        </div>
    </div>
@endif